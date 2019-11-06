#!/bin/sh
":" //# node shebang hack; exec /usr/bin/env node --use_strict "$0" "$@"

const path = require('path')
const { spawn, execFileSync } = require('child_process')
const readline = require('readline')

const argv = process.argv
const exit = process.exit
const print = console.log.bind(console)

class Prop {
    constructor(key, value = null) {
        this.key = key
        this.value = value
    }
}

class Sink {
    constructor(number) {
        this.number = number
        this.name = null
        this.volume = null
        this.mute = null
    }
}

function usage() {
    const name = path.basename(argv[1])
    print('Usage:')
    print(`  ${name} <action> [arguments...]`)
    print()
    print('ACTIONS:')
    print('    get-volume <sink-name>')
    print('        Get the volume of a given sink. See the information about')
    print('        the "sink-name" parameter in the parameter description')
    print('        below.')
    print('')
    print('    set-volume <sink-name> <volume>')
    print('        Set the volume of a given sink to the specified volume.')
    print('        See the information about the "sink-name" parameter in the')
    print('        parameter description below.')
    print('        The volume could either be absolute (e. g. "20%") or')
    print('        relative (e. g. "+5%").')
    print('')
    print('    set-mute <sink-name> 1|0|toggle')
    print('        Mute / unmute the given sink. See the information about')
    print('        the "sink-name" parameter in the parameter description')
    print('        below.')
    print('        "1" mutes the sink, "0" unmutes and "toggle" toggles the')
    print('        mute state.')
    print('')
    print('PARAMETERS')
    print('    sink-name:')
    print('        The sink name could either be the full name or the')
    print('        beginning of the name. If the name would match')
    print('        multiple sinks, the first one found will be used.')
    print('        So make sure the searched name is unambiguous.')
    print('')
}

function main() {
    requireArgs(1)
    const action = argv[2]

    switch (action) {
        case 'help':
        case '--help':
        case '-h':
            usage()
            break;

        case 'get-volume':
            requireArgs(2)
            getVolume(argv[3])
            break;

        case 'set-volume':
            requireArgs(3)
            setVolume(argv[3], argv[4])
            break;

        case 'set-mute':
            requireArgs(3)
            setMute(argv[3], argv[4])
            break;

        default:
            usage()
            exit(1)
    }
}

function requireArgs(length) {
    if (argv.length < (length + 2)) {
        console.error('ERROR: Not enought arguments.')
        exit(1)
    }
}

async function getVolume(sinkName) {
    const sink = await findSink(sinkName)

    if (sink.mute) {
        print('MUTE')
    } else {
        print(`${sink.volume}%`)
    }
}

async function setVolume(sinkName, volume) {
    const sink = await sinkInfo(sinkName)

    execFileSync('pactl', ['set-sink-volume', sink.name, volume])
}

async function setMute(sinkName, mute) {
    const sink = await findSink(sinkName)

    if (['1', '0', 'toggle'].includes(mute)) {
        execFileSync('pactl', ['set-sink-mute', sink.name, mute])
    } else {
        print(`ERROR: Invalid parameter "${mute}". Expected "1" | "0" | "toggle".`)
        exit(1)
    }
}

async function sinkInfo(instance) {
    return new Promise((resolve, reject) => {
        const process = spawn('pactl', ['list', 'sinks'])
        const lineReader = readline.createInterface(process.stdout)
        let sink = null
        let parse = true

        lineReader.on('line', (line) => {
            if (!parse) return

            line = line.toString().trimRight()

            const indent = getIndentLevel(line)

            if (line.length === 0) {
                return
            }

            if (indent === 0) {
                const prop = parseLine(line, {separator: ' #'})

                if (prop.key !== 'Sink') {
                    throw new Error(`Expected new sink, got "${prop.key}"`)
                }

                if (sink !== null) {
                    // A sink has already been found. We do not need to parse
                    // a new one.
                    process.kill()
                    parse = false // disable further parsing
                    resolve(sink)
                    return
                }

                sink = new Sink(prop.value)
            } else if (sink === null) {
                // Ignore indented lines when there is no sink
                return
            } else if (indent === 1) {
                const prop = parseLine(line)

                switch (prop.key) {
                    case 'Name':
                        const name = prop.value

                        if (!name.startsWith(instance)) {
                            // Set sink to null to indicate that the currently
                            // parsed sink is not the one being searched.
                            sink = null
                            return
                        }

                        sink.name = name
                        break
                    case 'Volume':
                        parseVolume(prop.value)
                        sink.volume = parseVolume(prop.value)
                        break
                    case 'Mute':
                        sink.mute = (prop.value === 'yes')
                        break
                }
            }
        })

        process.once('exit', (code) => {
            if (code === 0) {
                resolve(sink)
            } else {
                reject(new Error(`pactl exited with code "${code}".`))
            }
        })
    })
}

function parseLine(line, {separator = ': '}={}) {
    line = line.trim()

    const split = line.indexOf(separator)

    if (split === -1) {
        return new Prop(null, line)
    }

    return new Prop(
        line.substr(0, split),
        line.substr(split+separator.length)
    )
}

function parseVolume(volumeStr) {
    // Volume string seems to be
    //   front-left: <raw-value> / <percent>% / <decibel> db, front-right: ...
    const volume = volumeStr.match('([0-9]+)%')

    if (volume === null) {
        throw new Error(`Failed parsing volume string: "${volumeStr}".`)
    }

    return volume[1]
 
}

function getIndentLevel(line, {tabsize=4}={}) {
    let spaces;
    line = line.expandTabs(tabsize)

    if (line.trim().length === 0) {
        spaces = 0
    } else {
        spaces = line.length - line.trimLeft().length
    }

    return (spaces / tabsize)
}

String.prototype.expandTabs = function(tabSize = 8) {
    var spaces = new Array(tabSize + 1).join(" ")

    return this.replace(/([^\r\n\t]*)\t/g, function(a, b) {
        return b + spaces.slice(b.length % tabSize)
    })
}

async function findSink(instance) {
    const sink = await sinkInfo(instance)

    if (sink === null) {
        console.error(`ERROR: Sink with name "${instance}" not found!`)
        exit(1)
    }

    return sink
}

main()

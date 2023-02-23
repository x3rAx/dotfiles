export-env {
    let default = 'white'

    let-env config = ($env | default {} config).config
    let-env config = ($env.config | default {} color_config)

    let orig = ($env.config.color_config | default $default string).string

    let-env config = ($env.config | update color_config ($env.config.color_config | merge {
        string: {
            if $in =~ '^#[0-9a-f]{6}$' {
                print $"COLOR: HTML \(($in)\)"
                #let rgb = ($in | str replace '#' '0x' | into int | into binary | get 2 1 0 | into record | rename R G B)
                let rgb = ($in | str replace '#' '0x' | into int | into binary | get 2 1 0)
                let lum = ($rgb.0 * 0.2126 + $rgb.1 * 0.7152 + $rgb.2 * 0.0722)
                let fg = (if $lum < 140 { '#ffffff' } else { '#000000' })

                {fg: $fg bg: $in}
            } else {
                # Use original value to get color
                $in | $orig
            }
        }
    }))
}


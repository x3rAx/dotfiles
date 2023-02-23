let x3ro = {
  config-dir: ($nu.config-path | path dirname | path join "x3ro")
}
let x3ro = ($x3ro | merge {
  env-path: ($x3ro.config-dir | path join "env.nu")
  config-path: ($x3ro.config-dir | path join "config.nu")
})

# Create the "generated" directory
mkdir ($x3ro.config-dir | path join "generated")

zoxide init nushell | save -f ($x3ro.config-dir | path join "generated" "zoxide.nu")

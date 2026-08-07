const fs = require('fs')
const path = require('path')

// --- 1. The Fluent Builder API ---

const APP_ITERM = {
  type: 'frontmost_application_if',
  bundle_identifiers: ['com.googlecode.iterm2'],
}
const IN_COPY_MODE = { type: 'variable_if', name: 'copyMode', value: 1 }

const toArray = (val) => (val ? (Array.isArray(val) ? val : [val]) : [])

function mapKey(fromKey, mandatoryMods, optionalMods) {
  const rule = {
    type: 'basic',
    conditions: [APP_ITERM], // Automatically scope all rules to iTerm2
    from: { key_code: fromKey },
    to: [],
  }

  const mandatory = toArray(mandatoryMods)
  const optional = toArray(optionalMods)

  if (mandatory.length || optional.length) {
    rule.from.modifiers = {}
    if (mandatory.length) rule.from.modifiers.mandatory = mandatory
    if (optional.length) rule.from.modifiers.optional = optional
  }

  // The "Chain" object returns itself, allowing method chaining (.to().to().setVar())
  const chain = {
    desc: (text) => {
      rule.description = `iTerm2: ${text}`
      return chain
    },
    ifCopyMode: () => {
      rule.conditions.push(IN_COPY_MODE)
      return chain
    },
    to: (key, mods) => {
      const modifiers = toArray(mods)
      rule.to.push(modifiers.length ? { key_code: key, modifiers } : { key_code: key })
      return chain
    },
    setVar: (name, value) => {
      rule.to.push({ set_variable: { name, value } })
      return chain
    },
    // Finally, extract the constructed rule object
    build: () => rule,
  }

  return chain
}

// --- 2. Defining the Rules ---

const manipulators = [
  // Enter / Exit Copy Mode
  mapKey('c', ['left_command', 'left_shift'])
    .desc('Enter copyMode')
    .to('c', ['left_command', 'left_shift'])
    .setVar('copyMode', 1),

  mapKey('c', 'left_command').ifCopyMode().desc('Copy & exit mode').to('y').setVar('copyMode', 0),

  mapKey('caps_lock').ifCopyMode().desc('Exit and reset mode').to('escape').to('escape'),

  // Navigation (Copy Mode)
  mapKey('m', 'right_command').ifCopyMode().desc('Home -> 0').to('0'),

  mapKey('slash', 'right_command').ifCopyMode().desc('End -> $').to('4', 'left_shift'),

  // Selection (Copy Mode)
  mapKey('m', ['right_command', 'left_shift'])
    .ifCopyMode()
    .desc('Select to Home')
    .to('spacebar')
    .to('0'),

  mapKey('slash', ['right_command', 'left_shift'])
    .ifCopyMode()
    .desc('Select to End')
    .to('spacebar')
    .to('4', 'left_shift'),

  mapKey('d', 'left_command')
    .ifCopyMode()
    .desc('Select word')
    .to('right_arrow', 'left_option')
    .to('left_arrow', 'left_option')
    .to('spacebar')
    .to('right_arrow', 'left_option'),

  // Fallbacks / Overrides (Normal Mode)
  mapKey('p', ['left_command', 'left_shift']).desc('Disable app palette').to('vk_none'),

  mapKey('m', 'right_command', 'any').desc('Native Home').to('home'),

  mapKey('slash', 'right_command', 'any').desc('Native End').to('end'),
].map((rule) => rule.build()) // Convert all chained builders into standard objects

// --- 3. Construct Output & Save ---

const karabinerConfig = {
  title: 'Generated complex modifications',
  description: 'Generated complex modifications',
  rules: [
    {
      description: '🔴 iTerm2 Overwrite',
      manipulators: manipulators,
    },
  ],
}

const outputPath = path.join(process.cwd(), 'karabiner-elements.json')
fs.writeFileSync(outputPath, JSON.stringify(karabinerConfig, null, 2), 'utf-8')
console.log(`✅ File generated successfully at:\n${outputPath}`)

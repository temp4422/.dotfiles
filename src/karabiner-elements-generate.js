const fs = require('fs')
const path = require('path')

// --- 1. Abstract Condition & Key Helpers ---

const appIf = (...bundles) => ({ type: 'frontmost_application_if', bundle_identifiers: bundles })
const varIf = (name, value = 1) => ({ type: 'variable_if', name, value })

const APP_ITERM = appIf('com.googlecode.iterm2')
const IN_COPY_MODE = varIf('copyMode', 1)
const IN_COPY_MODE_SPACE = varIf('copyModeSpace', 1)

const toArray = (val) => (val ? (Array.isArray(val) ? val : [val]) : [])

const buildKey = (key_code, mandatory, optional) => {
  const mand = toArray(mandatory)
  const opt = toArray(optional)
  const result = { key_code }
  if (mand.length || opt.length) {
    result.modifiers = {}
    if (mand.length) result.modifiers.mandatory = mand
    if (opt.length) result.modifiers.optional = opt
  }
  return result
}

const buildTo = (key_code, mods) => {
  const modifiers = toArray(mods)
  return modifiers.length ? { key_code, modifiers } : { key_code }
}

// --- 2. Abstracted Fluent Builder API ---

function mapKey(fromKey, mandatoryMods, optionalMods) {
  const rule = {
    type: 'basic',
    conditions: [APP_ITERM],
    from: buildKey(fromKey, mandatoryMods, optionalMods),
    to: [],
  }

  const chain = {
    desc: (text) => ((rule.description = `iTerm2: ${text}`), chain),
    when: (...conditions) => (rule.conditions.push(...conditions.flat()), chain),
    ifVar: (name, value = 1) => chain.when(varIf(name, value)),
    to: (key, mods) => (rule.to.push(buildTo(key, mods)), chain),
    setVar: (name, value) => (rule.to.push({ set_variable: { name, value } }), chain),
    build: () => rule,
  }

  return chain
}

// --- 3. Defining the Rules ---

const manipulators = [
  // Enter / Exit Copy Mode
  mapKey('c', ['left_command', 'left_shift'])
    .desc('Enter copyMode')
    .to('c', ['left_command', 'left_shift'])
    .setVar('copyMode', 1),

  mapKey('c', 'left_command')
    .ifVar('copyMode', 1)
    .desc('Copy & exit mode')
    .to('y')
    .setVar('copyMode', 0)
    .setVar('copyModeSpace', 0),

  mapKey('caps_lock')
    .ifVar('copyMode', 1)
    .desc('Exit and reset mode')
    .to('escape')
    .to('escape')
    .setVar('copyMode', 0)
    .setVar('copyModeSpace', 0),

  // Navigation (Copy Mode)

  // hoome/end/page_up/page_down
  mapKey('m', 'right_command')
    .ifVar('copyMode', 1)
    .desc('Home -> 0')
    .to('0')
    .setVar('copyModeSpace', 0),

  mapKey('slash', 'right_command')
    .ifVar('copyMode', 1)
    .desc('End -> $')
    .to('4', 'left_shift')
    .setVar('copyModeSpace', 0),

  // jkl;
  mapKey('j', ['right_command'])
    .ifVar('copyMode', 1)
    .ifVar('copyModeSpace', 0)
    .desc('Move to left')
    .to('left_arrow'),

  mapKey('j', ['right_command'])
    .ifVar('copyMode', 1)
    .ifVar('copyModeSpace', 1)
    .desc('Move to left')
    .to('spacebar')
    .to('left_arrow')
    .setVar('copyModeSpace', 0),

  mapKey('k', ['right_command'])
    .ifVar('copyMode', 1)
    .ifVar('copyModeSpace', 0)
    .desc('Move to down')
    .to('down_arrow'),

  mapKey('k', ['right_command'])
    .ifVar('copyMode', 1)
    .ifVar('copyModeSpace', 1)
    .desc('Move to down')
    .to('spacebar')
    .to('down_arrow')
    .setVar('copyModeSpace', 0),

  mapKey('l', ['right_command'])
    .ifVar('copyMode', 1)
    .ifVar('copyModeSpace', 0)
    .desc('Move to up')
    .to('up_arrow'),

  mapKey('l', ['right_command'])
    .ifVar('copyMode', 1)
    .ifVar('copyModeSpace', 1)
    .desc('Move to up')
    .to('spacebar')
    .to('up_arrow')
    .setVar('copyModeSpace', 0),

  mapKey('semicolon', ['right_command'])
    .ifVar('copyMode', 1)
    .ifVar('copyModeSpace', 0)
    .desc('Move to right')
    .to('right_arrow'),

  mapKey('semicolon', ['right_command'])
    .ifVar('copyMode', 1)
    .ifVar('copyModeSpace', 1)
    .desc('Move to right')
    .to('spacebar')
    .to('right_arrow')
    .setVar('copyModeSpace', 0),

  // Selection (Copy Mode)

  // hoome/end/page_up/page_down
  mapKey('m', ['right_command', 'left_shift'])
    .ifVar('copyMode', 1)
    .desc('Select to Home')
    .to('spacebar')
    .to('left_arrow', 'left_command'),

  mapKey('slash', ['right_command', 'left_shift'])
    .ifVar('copyMode', 1)
    .desc('Select to End')
    .to('spacebar')
    .to('right_arrow', 'left_command'),

  // jkl;
  mapKey('j', ['right_command', 'left_shift'])
    .ifVar('copyMode', 1)
    .ifVar('copyModeSpace', 0)
    .desc('Select to left')
    .to('spacebar')
    .to('left_arrow')
    .setVar('copyModeSpace', 1),

  mapKey('j', ['right_command', 'left_shift'])
    .ifVar('copyMode', 1)
    .ifVar('copyModeSpace', 1)
    .desc('Select to left in copyModeSpace')
    .to('left_arrow'),

  mapKey('k', ['right_command', 'left_shift'])
    .ifVar('copyMode', 1)
    .ifVar('copyModeSpace', 0)
    .desc('Select to down')
    .to('spacebar')
    .to('down_arrow')
    .setVar('copyModeSpace', 1),

  mapKey('k', ['right_command', 'left_shift'])
    .ifVar('copyMode', 1)
    .ifVar('copyModeSpace', 1)
    .desc('Select to down in copyModeSpace')
    .to('down_arrow'),

  mapKey('l', ['right_command', 'left_shift'])
    .ifVar('copyMode', 1)
    .ifVar('copyModeSpace', 0)
    .desc('Select to up')
    .to('spacebar')
    .to('up_arrow')
    .setVar('copyModeSpace', 1),

  mapKey('l', ['right_command', 'left_shift'])
    .ifVar('copyMode', 1)
    .ifVar('copyModeSpace', 1)
    .desc('Select to up in copyModeSpace')
    .to('up_arrow'),

  mapKey('semicolon', ['right_command', 'left_shift'])
    .ifVar('copyMode', 1)
    .ifVar('copyModeSpace', 0)
    .desc('Select to right')
    .to('spacebar')
    .to('right_arrow')
    .setVar('copyModeSpace', 1),

  mapKey('semicolon', ['right_command', 'left_shift'])
    .ifVar('copyMode', 1)
    .ifVar('copyModeSpace', 1)
    .desc('Select to right in copyModeSpace')
    .to('right_arrow'),

  // select world
  mapKey('d', 'left_command')
    .ifVar('copyMode', 1)
    .desc('Select word')
    .to('right_arrow', 'left_option')
    .to('left_arrow', 'left_option')
    .to('spacebar')
    .to('right_arrow', 'left_option'),

  // Fallbacks / Overrides (Normal Mode)
  mapKey('p', ['left_command', 'left_shift']).desc('Disable app palette').to('vk_none'),

  mapKey('m', 'right_command', 'any').desc('Native Home').to('home'),

  mapKey('slash', 'right_command', 'any').desc('Native End').to('end'),
].map((rule) => rule.build())

// --- 4. Construct Output & Save ---

const karabinerConfig = {
  title: 'Generated complex modifications',
  description: 'Generated complex modifications',
  rules: [
    {
      description: '🔴 iTerm2 Overwrite GENERATED',
      manipulators: manipulators,
    },
  ],
}

const outputPath = path.join(__dirname, 'karabiner-elements.json')
fs.writeFileSync(outputPath, JSON.stringify(karabinerConfig, null, 2), 'utf-8')
console.log(`✅ File generated successfully at:\n${outputPath}`)

const fs = require('fs')
const path = require('path')
const child_process = require('child_process')

const { Console } = require('console')
const myLogger = new Console({ stdout: fs.createWriteStream('normalStdout.txt') }) // myLogger.log('This will be logged to normalStdout.txt file')

console.log('SCRIPT START OK')

async function remnoteToObsidian() {
  // // 1. Rename Daily Documents to daily
  // const source1 = '/Users/user/Downloads/RemNoteExport/Daily Documents'
  // const target1 = '/Users/user/Downloads/RemNoteExport/daily'

  // try {
  //   if (fs.existsSync('/Users/user/Downloads/RemNoteExport/Daily Documents')) {
  //     fs.renameSync(source1, target1, (err) => {
  //       console.log(`1. ERROR Rename from ${source1} to ${target1}`)
  //     })
  //   }
  // } catch (e) {
  //   console.log(e)
  // } finally {
  //   console.log(`1. SUCCESS Rename from ${source1} to ${target1}`)
  // }

  // // 2. Move all .html files to ~ folder
  // const source2 = '/Users/user/Downloads/RemNoteExport/'
  // const target2 = '/Users/user/Downloads/RemNoteExport/~/'
  // const ext = '.html'

  // try {
  //   console.log('OK')
  //   // if (!fs.existsSync('/Users/user/Downloads/RemNoteExport/~/')) {
  //   await fs.mkdirSync('/Users/user/Downloads/RemNoteExport/~/')
  //   console.log('OK2')
  //   // }
  //   await fs.readdirSync(source2).forEach((file) => {
  //     if (path.extname(file).toLowerCase() == ext) {
  //       fs.renameSync(source2 + file, target2 + file)
  //     }
  //   })
  // } catch (e) {
  //   console.log(e)
  // } finally {
  //   console.log(`2. SUCCESS Moved .html files from ${source2} to ${target2}`)
  // }

  // // 3. Remove all folders excep few
  // const source3 = '/Users/user/Downloads/RemNoteExport/'
  // const exclude3_1 = '/Users/user/Downloads/RemNoteExport/~'
  // const exclude3_2 = '/Users/user/Downloads/RemNoteExport/daily'

  // const readdirSync = (p, a = []) => {
  //   if (fs.statSync(p).isDirectory())
  //     fs.readdirSync(p).map((f) => readdirSync(a[a.push(path.join(p, f)) - 1], a))
  //   return a
  // }
  // const files3 = readdirSync(source3)

  // files3.forEach((file) => {
  //   // const fileDir = path.join(source3, file)
  //   if (file == exclude3_1 || file == exclude3_2) {
  //     // Do nothing, skip folders
  //   } else {
  //     fs.rmSync(file, { recursive: true, force: true }) // Remove folders
  //   }
  // })
  // console.log(`3. SUCCESS Removed all folders except ${exclude3_1} and ${exclude3_2}`)

  // // 4. Convert html to md

  // child_process.execSync('sh remnote-to-obsidian.sh', (error, stdout, stderr) => {
  //   console.log(stdout)
  //   console.log(stderr)
  //   if (error !== null) console.log(`exec error: ${error}`)
  // })
  // console.log(`5. SUCCESS Convert html to md`)

  // // 5. Remove `\`
  // const source6 = '/Users/user/Downloads/RemNoteExport'

  // const readdirSync = (p, a = []) => {
  //   if (fs.statSync(p).isDirectory())
  //     fs.readdirSync(p).map((f) => readdirSync(a[a.push(path.join(p, f)) - 1], a))
  //   return a
  // }
  // const files = readdirSync(source6)

  // const file = files[0]

  // files.forEach((file) => {
  //   fs.readFile(file, 'utf8', (err, data) => {
  //     if (err) return console.log(err)
  //     let result = data.replace(/\\\n/, '')

  //     fs.writeFile(file, result, 'utf8', (err) => {
  //       if (err) return console.log(err)
  //     })
  //   })
  // })

  // console.log(`6. SUCCESS Remove /`)

  // // 99. Copy assets
  // const source4 = '/Users/user/remnote/remnote-60d0a8d64cff290034528346/files'
  // const target4 = '/Users/user/Downloads/RemNoteExport/assets'

  // fs.cpSync(source4, target4, { recursive: true })
  // console.log(`4. SUCCESS Copy assets from ${source4} to ${target4}`)
}
remnoteToObsidian()

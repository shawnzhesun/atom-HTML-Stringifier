module.exports =
  activate: (state) ->
    atom.commands.add("atom-workspace", "HTMLStringify:Stringify", => @stringify())
    atom.commands.add("atom-workspace", "HTMLStringify:Unstringify", => @unstringify())

  stringify: ->
    editor = atom.workspace.getActiveTextEditor()
    return if !editor

    selectedText = editor.getSelectedText()
    convertText = selectedText.split('\n').map((line) =>
      trimedText = line.trimLeft()
      toggledText = trimedText.replace(/"/g, '\'')
      spaceCount = line.indexOf(trimedText)
      space = ''
      for i in [0...spaceCount]
        space += ' '
      return "#{space}\"#{toggledText}\""
    ).join(' +\n')

    editor.insertText(convertText,
      select: true
    )

  unstringify: ->
    editor = atom.workspace.getActiveTextEditor()
    return if !editor

    selectedText = editor.getSelectedText()
    convertText = selectedText.split('\n').map((line) =>
      trimedText = line.trim()
        .replace(/\s?\+\s?/, '')
        .replace(/^"/, '')
        .replace(/"$/, '')
      spaceCount = line.indexOf(trimedText)
      trimedText = trimedText
        .replace(/'/g, '"')
      space = ''
      for i in [0...spaceCount-1]
        space += ' '
      return "#{space}#{trimedText}"
    ).join('\n')

    editor.insertText(convertText,
      select: true
    )

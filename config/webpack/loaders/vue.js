function removeAttr(astEl, name) {
  const { attrsList, attrsMap } = astEl
  if (attrsMap[name]) {
    delete attrsMap[name]
    const index = attrsList.findIndex((x) => x.name === name)
    attrsList.splice(index, 1)
  }
  return astEl
}

function removeTestAttr(astEl) {
  removeAttr(astEl, 'data-test-id')
  removeAttr(astEl, ':data-test-id')
  return astEl
}

const compileModules =
  process.env.NODE_ENV === 'production'
    ? [{ preTransformNode: removeTestAttr }]
    : []

module.exports = {
  test: /\.vue$/,
  loader: 'vue-loader',
  options: {
    reactivityTransform: true,
    compilerOptions: {
      modules: compileModules
    }
  }
}

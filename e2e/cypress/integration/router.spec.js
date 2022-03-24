describe('Router', () => {
  context('when access page with invalid url', () => {
    it('should show 404', () => {
      cy.visit('/this-is-invalid-url')
      cy.contains('404: Not Found').should('be.visible')
    })
  })
})

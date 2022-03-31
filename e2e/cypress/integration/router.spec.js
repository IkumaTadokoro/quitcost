describe('Router', () => {
  beforeEach(() => {
    cy.clock(new Date(2022, 3, 15), ['Date'])
  })

  context('when access page with invalid url', () => {
    it('should show 404', () => {
      cy.visit('/this-is-invalid-url')
      cy.contains('404: Not Found').should('be.visible')
    })
  })

  context('when access result page without answering all questions', () => {
    context('when current page is simulations/new/*', () => {
      it('should redirect current step', () => {
        cy.visit('/')
        cy.contains('いますぐ計算する').click()

        cy.contains('退職予定月').should('be.visible')
        cy.get('input').type('202206')
        cy.contains('つぎの質問へ').click()

        cy.visit('/simulations')
        cy.contains('転職予定月').should('be.visible')
      })

      it('should redirect current page even if press the back or next button', () => {
        cy.visit('/')
        cy.contains('いますぐ計算する').click()

        cy.contains('退職予定月').should('be.visible')
        cy.get('input').type('202206')
        cy.contains('つぎの質問へ').click()

        cy.contains('転職予定月').should('be.visible')
        cy.get('input').type('202303')

        cy.contains('つぎの質問へ').click()
        cy.contains('年齢').should('be.visible')

        cy.contains('まえの質問へ').click()
        cy.contains('転職予定月').should('be.visible')

        cy.contains('まえの質問へ').click()
        cy.contains('退職予定月').should('be.visible')

        cy.contains('つぎの質問へ').click()
        cy.contains('転職予定月').should('be.visible')

        cy.visit('/simulations')
        cy.contains('転職予定月').should('be.visible')
      })
    })

    context('when current page is NOT simulations/new/*', () => {
      it('should redirect first step of simulation', () => {
        cy.visit('/')
        cy.contains('いますぐ計算する').click()
        cy.contains('退職予定月').should('be.visible')

        cy.visit('/simulations')
        cy.contains('退職予定月').should('be.visible')
      })
    })
  })

  context(
    'when access simulations/new/* without answering previous questions',
    () => {
      context('when current page is simulations/new/*', () => {
        it('should redirect current step', () => {
          cy.visit('/')
          cy.contains('いますぐ計算する').click()

          cy.contains('退職予定月').should('be.visible')
          cy.get('input').type('202206')
          cy.contains('つぎの質問へ').click()

          cy.visit('/simulations/new/salary')
          cy.contains('転職予定月').should('be.visible')
        })

        it('should redirect current page even if press the back or next button', () => {
          cy.visit('/')
          cy.contains('いますぐ計算する').click()

          cy.contains('退職予定月').should('be.visible')
          cy.get('input').type('202206')
          cy.contains('つぎの質問へ').click()

          cy.contains('転職予定月').should('be.visible')
          cy.get('input').type('202303')

          cy.contains('つぎの質問へ').click()
          cy.contains('年齢').should('be.visible')

          cy.contains('まえの質問へ').click()
          cy.contains('転職予定月').should('be.visible')

          cy.contains('まえの質問へ').click()
          cy.contains('退職予定月').should('be.visible')

          cy.contains('つぎの質問へ').click()
          cy.contains('転職予定月').should('be.visible')

          cy.visit('/simulations/new/salary')
          cy.contains('転職予定月').should('be.visible')
        })
      })

      context('when current page is NOT simulations/new/*', () => {
        it('should redirect first step of simulation', () => {
          cy.visit('/')
          cy.contains('いますぐ計算する').click()
          cy.contains('退職予定月').should('be.visible')

          cy.visit('/simulations/new/age')
          cy.contains('退職予定月').should('be.visible')
        })
      })
    }
  )
})

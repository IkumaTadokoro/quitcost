describe('Simulation', () => {
  describe('dynamic step', () => {
    beforeEach(() => {
      cy.clock(new Date(2022, 3, 15), ['Date']) // 日本時間午前9
    })

    context(
      'when retirementMonth < June and employmentMonth < next April',
      () => {
        it('should show 8 questions(essential + previous + current)', () => {
          cy.visit('/')
          cy.contains('いますぐ計算する').click()

          cy.contains('退職予定月').should('be.visible')
          cy.get('input').type('202204')
          cy.contains('つぎの質問へ').click()

          cy.contains('転職予定月').should('be.visible')
          cy.get('input').type('202303')
          cy.contains('つぎの質問へ').click()

          cy.contains('年齢').should('be.visible')
          cy.get('input').type('20')
          cy.contains('つぎの質問へ').click()

          cy.contains('郵便番号').should('be.visible')
          cy.get('input').type('1000004{enter}')
          cy.contains('つぎの質問へ').click()
          cy.wait(500)
          cy.contains('つぎの質問へ').click()

          cy.contains('昨昨年度').should('be.visible')
          cy.contains('所得').should('be.visible')
          cy.get('input').type('5000000')
          cy.contains('つぎの質問へ').click()

          cy.contains('昨昨年度').should('be.visible')
          cy.contains('社会保険料').should('be.visible')
          cy.contains('おまかせで入力する').click()
          cy.contains('つぎの質問へ').click()

          cy.contains('昨年度').should('be.visible')
          cy.contains('所得').should('be.visible')
          cy.get('input').type('5000000')
          cy.contains('つぎの質問へ').click()

          cy.contains('昨年度').should('be.visible')
          cy.contains('社会保険料').should('be.visible')
          cy.contains('おまかせで入力する').click()
          cy.contains('計算結果へ').should('be.visible')
        })
      }
    )

    context(
      'when retirementMonth >= June and < next June, and employmentMonth < next April',
      () => {
        it('should show 6 questions(essential + current)', () => {
          cy.visit('/')
          cy.contains('いますぐ計算する').click()

          cy.contains('退職予定月').should('be.visible')
          cy.get('input').type('202206')
          cy.contains('つぎの質問へ').click()

          cy.contains('転職予定月').should('be.visible')
          cy.get('input').type('202303')
          cy.contains('つぎの質問へ').click()

          cy.contains('年齢').should('be.visible')
          cy.get('input').type('20')
          cy.contains('つぎの質問へ').click()

          cy.contains('郵便番号').should('be.visible')
          cy.get('input').type('1000004{enter}')
          cy.contains('つぎの質問へ').click()
          cy.contains('つぎの質問へ').click()

          cy.contains('昨年度').should('be.visible')
          cy.contains('所得').should('be.visible')
          cy.get('input').type('5000000')
          cy.contains('つぎの質問へ').click()

          cy.contains('昨年度').should('be.visible')
          cy.contains('社会保険料').should('be.visible')
          cy.contains('おまかせで入力する').click()
          cy.contains('計算結果へ').should('be.visible')
        })
      }
    )

    context(
      'when retirementMonth >= June and < next June, and employmentMonth > next April',
      () => {
        it('should show 8 questions(essential + current + scheduled)', () => {
          cy.visit('/')
          cy.contains('いますぐ計算する').click()

          cy.contains('退職予定月').should('be.visible')
          cy.get('input').type('202305')
          cy.contains('つぎの質問へ').click()

          cy.contains('転職予定月').should('be.visible')
          cy.get('input').type('202404')
          cy.contains('つぎの質問へ').click()

          cy.contains('年齢').should('be.visible')
          cy.get('input').type('20')
          cy.contains('つぎの質問へ').click()

          cy.contains('郵便番号').should('be.visible')
          cy.get('input').type('1000004{enter}')
          cy.contains('つぎの質問へ').click()
          cy.contains('つぎの質問へ').click()

          cy.contains('昨年度').should('be.visible')
          cy.contains('所得').should('be.visible')
          cy.get('input').type('5000000')
          cy.contains('つぎの質問へ').click()

          cy.contains('昨年度').should('be.visible')
          cy.contains('社会保険料').should('be.visible')
          cy.contains('おまかせで入力する').click()
          cy.contains('つぎの質問へ').click()

          cy.contains('今年度').should('be.visible')
          cy.contains('所得').should('be.visible')
          cy.get('input').type('5000000')
          cy.contains('つぎの質問へ').click()

          cy.contains('今年度').should('be.visible')
          cy.contains('社会保険料').should('be.visible')
          cy.contains('おまかせで入力する').click()
          cy.contains('計算結果へ').should('be.visible')
        })
      }
    )

    context('when retirementMonth >= next June', () => {
      it('should show 6 questions(essential + scheduled)', () => {
        cy.visit('/')
        cy.contains('いますぐ計算する').click()

        cy.contains('退職予定月').should('be.visible')
        cy.get('input').type('202306')
        cy.contains('つぎの質問へ').click()

        cy.contains('転職予定月').should('be.visible')
        cy.get('input').type('202404')
        cy.contains('つぎの質問へ').click()

        cy.contains('年齢').should('be.visible')
        cy.get('input').type('20')
        cy.contains('つぎの質問へ').click()

        cy.contains('郵便番号').should('be.visible')
        cy.get('input').type('1000004{enter}')
        cy.contains('つぎの質問へ').click()
        cy.contains('つぎの質問へ').click()

        cy.contains('今年度').should('be.visible')
        cy.contains('所得').should('be.visible')
        cy.get('input').type('5000000')
        cy.contains('つぎの質問へ').click()

        cy.contains('今年度').should('be.visible')
        cy.contains('社会保険料').should('be.visible')
        cy.contains('おまかせで入力する').click()
        cy.contains('計算結果へ').should('be.visible')
      })
    })
  })
})

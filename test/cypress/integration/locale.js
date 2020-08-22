describe('Locale', function() {
    
    it('Change language to portuguese', function() {

        cy.visit('/')
        
        cy.get('#nav-bar-header')
            .find('#active-language')
            .find('.item-language')      
            .click()
        
        cy.get('#nav-bar-header')
            .find('.available-languages')
            .find('.portuguese')      
            .click()

        cy.get('#nav-bar-header')
            .find('#active-language')
            .should('contain', 'Português')
                
    })

    it('Change language to portuguese through url', function() {
        
        cy.visit('/pt/')

        cy.get('#nav-bar-header')
            .find('#active-language')
            .should('contain', 'Português')
                
    })

    it('Change language to spanish', function() {
        
        cy.visit('/')
        
        cy.get('#nav-bar-header')
            .find('#active-language')
            .find('.item-language')      
            .click()
        
        cy.get('#nav-bar-header')
            .find('.available-languages')
            .find('.spanish')      
            .click()

        cy.get('#nav-bar-header')
            .find('#active-language')
            .should('contain', 'Spanish')
                
    })

    it('Change language to spanish through url', function() {
        
        cy.visit('/es/')
        
        cy.get('#nav-bar-header')
            .find('#active-language')
            .should('contain', 'Spanish')
                
    })

    it('Change language to dutch', function() {
        
        cy.visit('/')
        
        cy.get('#nav-bar-header')
            .find('#active-language')
            .find('.item-language')      
            .click()
        
        cy.get('#nav-bar-header')
            .find('.available-languages')
            .find('.dutch')      
            .click()

        cy.get('#nav-bar-header')
            .find('#active-language')
            .should('contain', 'Nederlands')
                
    })

    it('Change language to dutch through url', function() {
        
        cy.visit('/nl/')
        
        cy.get('#nav-bar-header')
            .find('#active-language')
            .should('contain', 'Nederlands')
                
    })

    it('Change language to english', function() {
        
        cy.visit('/pt/')
        
        cy.get('#nav-bar-header')
            .find('#active-language')
            .find('.item-language')      
            .click()
        
        cy.get('#nav-bar-header')
            .find('.available-languages')
            .find('.english')      
            .click()

        cy.get('#nav-bar-header')
            .find('#active-language')
            .should('contain', 'English')
                
    })

    it('Change language to english through url', function() {
        
        cy.visit('/en/')
        
        cy.get('#nav-bar-header')
            .find('#active-language')
            .should('contain', 'English')
                
    })
})
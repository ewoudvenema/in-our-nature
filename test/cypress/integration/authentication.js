describe('Authentication', function() {

    var user = new Date().getTime()

    it('Sign Up', function() {

        cy.visit('/')

        cy.get('.sign-up-button')      
            .click()
        
        cy.get('#sign-up')
            .find('#user_name')
            .type('John Doe')
        
        cy.get('#sign-up')
            .find('#user_email')
            .type(user+'@mail.com')
        
        cy.get('#sign-up')
            .find('#password')
            .type('JohnDoe#P4ssw0rd?')
        
        cy.get('#sign-up')
            .find('#confirmPassword')
            .type('JohnDoe#P4ssw0rd?')

        cy.get('#sign-up')
            .find('.sign-up-button')
            .find('.button')
            .click()
            
        cy.visit('/')
            .contains('John')
    })

    it('Sign In', function() {
        cy.visit('/')

        cy.get('.sign-in-button')      
            .click()
        
        cy.get('#login')
            .find('#user_email')
            .type(user+'@mail.com')
        
        cy.get('#login')
            .find('#user_password')
            .type('JohnDoe#P4ssw0rd?')
        
        cy.get('#login')
            .find('.sign-in-button')
            .find('.button')
            .click()
            
        cy.visit('/')
            .contains('John')
        
    })

    it('Log out', function() {
        cy.visit('/')

        cy.get('.sign-in-button')      
            .click()
        
        cy.get('#login')
            .find('#user_email')
            .type(user+'@mail.com')
        
        cy.get('#login')
            .find('#user_password')
            .type('JohnDoe#P4ssw0rd?')
        
        cy.get('#login')
            .find('.sign-in-button')
            .find('.button')
            .click()
            
        cy.visit('/user')

        cy.get('#logout-link')      
            .click()
        
        cy.visit('/user')
            .contains('SIGN')
        
    })
  })
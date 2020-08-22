describe('Homepage - Unauthenticated', function () {

    it('Follow community unauthenticated', function () {
        cy.visit('/')
        cy.get('.community-follow-button').first().click()
        cy.url().should('be', '/user')
    })
})


describe('Homepage - Authenticated ', function () {
    

    var user = new Date().getTime()
    
        before(function () {
            // First Sign Up
            cy.visit('/')
    
            cy.get('.sign-up-button')
                .click()
    
            cy.get('#sign-up')
                .find('#user_name')
                .type('John Doe')
    
            cy.get('#sign-up')
                .find('#user_email')
                .type(user + '@mail.com')
    
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

        })


    it('Follow community', function () {
                  
                cy.get('.community-user-follow-button').first().then(function($a){
                    const name = $a.prop('name')
                    $a.click()
                    cy.url().should('include', 'community/'+name)
                  })
                
            
            })
    }
)







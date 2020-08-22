describe('Community', function(){
    var user = new Date().getTime()

    before(function(){

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
    });

    var community = "Community "+new Date().getTime()

    it('Create Community', function(){
        
        cy.visit('/community/new');

        cy.get('#create-community')
            .find('#community_name')
            .type(community);

        cy.get('#create-community')
            .find('#community_description')
            .type('Descrição');
        
        cy.get('#create-community')
            .find('.button.submit-community')
            .click();

        cy.url().should('include', 'community/');

        cy.get('#community-container')
        .find('.community-name')
        .contains(community);
    });
});
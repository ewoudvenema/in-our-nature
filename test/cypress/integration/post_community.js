describe('Community', function(){
    var community = "Community "+new Date().getTime()

    before(function(){
        var user = new Date().getTime()
        
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
    });

    it('Post Community', function(){

        cy.get("#community-container")
            .find('#anchor-to-new-post')
            .click();

        cy.get('#community-container')
            .find('#new-post')
            .find('input[type=text]')
            .type("New post");
        
        cy.get('#community-container')
            .find('#new-post')
            .find('textarea')
            .type("New content");

        cy.get('#community-container')
            .find('#new-post')
            .find('#submit-new-post')
            .click();
    });
});
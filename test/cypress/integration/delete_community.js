/*
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

    it('Delete Community', function(){
        
        cy.get('#community-container',{
            force: true
            })
            .find('.setting',{
                force: true
            })
            .click({
                force: true
            });

        cy.get('#community-container')
            .find('.community-admin-options')
            .find('#get_confirmation_delete_community')
            .click();

        cy.get('#delete-confirmation-modal')
            .find('#confirmation-input-name')
            .type(community);

        cy.wait(10000);

        cy.get('#delete-confirmation-modal',{
            force: true
        })
            .find('#delete_community',{
                force: true
            })
            .click({
                force: true
            });

        cy.url().should('include', '/');
    });

});*/
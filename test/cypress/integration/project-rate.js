describe('Rate Project authenticated tests', function () {

  var user
  beforeEach(function () {
      user = new Date().getTime()
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
/*
    it('Rate project and delete rate', function () {
      cy.visit('/project/show/539');

      cy.get("#karma")
        .contains("0");

      cy.wait(10000);

      cy.get('#upvote')
        .click({
          force: true
        });

      cy.wait(10000);
      cy.reload();

      cy.get("#karma")
        .contains("1");

      cy.get('#upvote')
        .click({
          force: true
        });

      cy.wait(10000);
      cy.reload();

      cy.get("#karma")
        .contains("0");

    })

    it('Edit project rate', function () {
      cy.visit('/project/show/539');

      cy.get("#karma")
        .contains("0");

      cy.wait(10000);
      cy.reload();

      cy.get('#downvote')
        .click({
          force: true
        });

      cy.wait(10000);

      cy.get("#karma")
        .contains("-1");

      cy.get('#upvote')
        .click({
          force: true
        });

      cy.wait(10000);
      cy.reload();

      cy.get("#karma")
        .contains("1");

      cy.get('#upvote')
        .click({
          force: true
        });

      cy.wait(10000);

      cy.get("#karma")
        .contains("0");

    })*/
})

describe('Rate Project unauthenticated tests', function () {

    it('Rate project unauthenticated', function () {
      cy.visit('/project/show/1');

      cy.get("#karma")
        .contains("0");

      cy.get('#upvote')
        .click({
          force: true
        });

      cy.wait(10000);

      cy.get("#karma")
        .contains("0");

      cy.get('#downvote')
        .click({
          force: true
        });

      cy.wait(10000);

      cy.get("#karma")
        .contains("0");

    })

})

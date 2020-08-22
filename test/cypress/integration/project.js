describe('Project tests - Unauthenticated', function () {

    it('Launch project unauthenticated', function () {
        cy.visit('/project/new');
        cy.url().should('include', '/user');
    })

})

describe('Project tests - Authenticated', function () {

    var user = new Date().getTime()

    beforeEach(function () {
        user = new Date().getTime();

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


  /*  it('Launch project Authenticated', function () {

        cy.visit('/project/new')

        cy.get("#project_vision_name")
            .type(user)

        cy.get("#project_planning")
            .type('Dummy planing')

        cy.get("#project_vision")
            .type('Dummy vision')

        cy.get("#project_benefits")
            .type('Dummy benefits')

        cy.get("#project_fund_asked")
            .type('1234')

        cy.get("#project_fund_limit_date")
            .type('12/12/2018')

        cy.get("#project_website")
            .type('www.project.com')

        cy.get("#project_category_id")
            .select('Nature', {
                force: true
            })

        cy.wait(2000);

        cy.get("#community_search div >input")
          .type('Nature')

        cy.wait(2000);

        cy.get("#community_search div >input")
          .clear()
          .type('Nature')

        cy.get("#project_impact")
            .select('National', {
                force: true
            });

        cy.get("#project_location")
            .type('Lisboa, Portugal')


        cy.get('form').submit()

        cy.url().should('include', '/project/show/')

        cy.get('.project-title')
          .contains(user);

        cy.get('#karma')
          .contains("0");

        cy.get('.project-params')
          .contains('Lisboa, Portugal');

        cy.get('.project-params')
          .contains('National');

        cy.get('#project-pledged-value')
          .contains('0');

        cy.get('#project-goal-value')
          .contains('1234');

        cy.get('.project-info-text')
          .contains('Dummy vision');

        cy.get('.project-info-text')
          .contains('Dummy planing');

        cy.get('.project-info-text')
          .contains('Dummy benefits');

    })


    it('Edit project Authenticated', function () {

        cy.visit('/project/new')

        cy.get("#project_vision_name")
            .type(user)

        cy.get("#project_planning")
            .type('Dummy planing')

        cy.get("#project_vision")
            .type('Dummy vision')

        cy.get("#project_benefits")
            .type('Dummy benefits')

        cy.get("#project_fund_asked")
            .type('1234')

        cy.get("#project_fund_limit_date")
            .type('12/12/2018')

        cy.get("#project_website")
            .type('www.project.com')

        cy.get("#project_category_id")
            .select('Nature', {
                force: true
            })

        cy.wait(2000);

        cy.get("#community_search div >input")
          .type('Nature')

        cy.wait(2000);

        cy.get("#community_search div >input")
          .clear()
          .type('Nature')

        cy.get("#project_impact")
          .select('National', {
              force: true
          })

        cy.get("#project_location")
          .type('Lisboa, Portugal');


        cy.get('form').submit()

        cy.url().should('include', '/project/show/')

        cy.get('.project-title')
          .contains(user);

        cy.get('#karma')
          .contains("0");

        cy.get('.project-params')
          .contains('Lisboa, Portugal');

        cy.get('.project-params')
          .contains('National');

        cy.get('#project-pledged-value')
          .contains('0');

        cy.get('#project-goal-value')
          .contains('1234');

        cy.get('.project-info-text')
          .contains('Dummy vision');

        cy.get('.project-info-text')
          .contains('Dummy planing');

        cy.get('.project-info-text')
          .contains('Dummy benefits');

        cy.get('#settings')
          .click();

        cy.get('#editProjectBtn')
          .click();

        cy.url().should('include', '/edit')

        cy.get("#project_vision_name")
          .clear()
          .type("edit"+user)

        cy.get("#project_planning")
          .clear()
          .type('Edited dummy planing')

        cy.get("#project_vision")
          .clear()
          .type('Edited dummy vision')

        cy.get("#project_benefits")
          .clear()
          .type('Edited dummy benefits')

        cy.get("#project_fund_asked")
          .clear()
          .type('1235')

        cy.get("#project_location")
          .clear()
          .type('Porto, Portugal')

        cy.get('form').submit()

        cy.url().should('include', '/project/show/')

        cy.get('.project-title')
          .contains("edit"+user);

        cy.get('#project-goal-value')
          .contains('1235');

        cy.get('.project-info-text')
          .contains('Edited dummy vision');

        cy.get('.project-info-text')
          .contains('Edited dummy planing');

        cy.get('.project-info-text')
          .contains('Edited dummy benefits');

        cy.get('.project-params')
          .contains('Porto, Portugal');

    })
*/

})

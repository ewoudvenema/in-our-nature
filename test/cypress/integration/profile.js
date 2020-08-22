describe('Profile Page Update user info', function () {

    beforeEach(function () {

        var user = new Date().getTime()

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

    it('Update user info', function () {

        cy.get('#nav-user-info i ').click({
            force: true
        })
        cy.get('#user-dropdown-menu a').first().click({
            force: true
        })

        cy.url().should('include', 'user/')

        //Update Name
        cy.get('.name').clear().type('New John Dow')

        cy.get('.general-info-form .ui.button').click()
        cy.get('.name').should('have.value', 'New John Dow')
    })

})

describe('Delete account', function () {

    var user = new Date().getTime()
    before(function () {
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

    it('Delete user', function () {
        cy.get('#nav-user-info i ').click({
            force: true
        })

        cy.get('#user-dropdown-menu a').contains('My Profile').click({
            force: true
        })

        cy.get('.header.delete-account').click()

        cy.get('#delete-account-modal').should('be.visible')

        cy.get('.delete-account-button').click({
            force: true
        })

        cy.wait(1000)

        cy.visit('/')
    })

    // afterEach('Try to sign in', function () {

    //     cy.visit('/user')

    //     cy.wait(1000)

    //     cy.get('#login')
    //         .find('#user_email')
    //         .type(user + '@mail.com')

    //     cy.get('#login')
    //         .find('#user_password')
    //         .type('JohnDoe#P4ssw0rd?')

    //     cy.get('#login')
    //         .find('.sign-in-button')
    //         .find('.button')
    //         .click()

    //     cy.get('.ui.negative.message').contains('The account was deleted.')

    // })
})


// describe('Change Password', function () {

//     var user = new Date().getTime()
//     before(function () {
//         cy.visit('/')

//         cy.get('.sign-up-button')
//             .click()

//         cy.get('#sign-up')
//             .find('#user_name')
//             .type('John Doe')

//         cy.get('#sign-up')
//             .find('#user_email')
//             .type(user + '@mail.com')

//         cy.get('#sign-up')
//             .find('#password')
//             .type('JohnDoe#P4ssw0rd?')

//         cy.get('#sign-up')
//             .find('#confirmPassword')
//             .type('JohnDoe#P4ssw0rd?')

//         cy.get('#sign-up')
//             .find('.sign-up-button')
//             .find('.button')
//             .click()
//     })

//     it('Change Password user', function () {
//         cy.get('#nav-user-info i ').click({
//             force: true
//         })

//         cy.get('#user-dropdown-menu a').contains('My Profile').click({
//             force: true
//         })

//         cy.get('.header.change-password').click()

//         cy.get('#your-password-id').type('JohnDoe#P4ssw0rd?').click({
//             force: true
//         })
//         cy.get('#new-password-id').type('newpassword123').click({
//             force: true
//         })
//         cy.get('#confirm-password-id').type('newpassword123').click({
//             force: true
//         })

//         cy.get('#submit-change-password').click()

//         cy.visit("/user")

//         cy.get('#logout-link').click()

//     });

//     afterEach('Try to sign in', function () {

//         cy.visit('/user')

//         cy.wait(1000)

//         cy.get('#login')
//             .find('#user_email')
//             .type(user + '@mail.com')

//         cy.get('#login')
//             .find('#user_password')
//             .type('newpassword123')

//         cy.get('#login')
//             .find('.sign-in-button')
//             .find('.button')
//             .click()

//         cy.get('.ui.negative.message').contains('The account was deleted.')

//     })
// })
# Co-creative Universe

To start your Phoenix app:

  * Install dependencies with `mix deps.get`
  * Migrate your database with `mix ecto.migrate`
  * Install Node.js dependencies with `cd assets && npm install`
  * Return to the root of the project `cd ..`
  * In the root of the project start Phoenix endpoint with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Necessary installed dependencies:
  * Elixir (https://elixir-lang.org/install.html)
    ``` 
      Ubuntu 14.04/16.04/16.10/17.04 or Debian 7/8/9
        Add Erlang Solutions repo: wget https://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb && sudo dpkg -i erlang-solutions_1.0_all.deb
        Run: sudo apt-get update
        Install the Erlang/OTP platform and all of its applications: sudo apt-get install esl-erlang
        Install Elixir: sudo apt-get install elixir
      
      Mac OS X
        Homebrew
            Update your homebrew to latest: brew update
            Run: brew install elixir
        Macports
            Run: sudo port install elixir
    ```
  * NodeJS (https://nodejs.org/en/download/)
    ```
      Ubuntu
        apt-get install nodejs-legacy
    ```

  * On Unix systems also install: inotify-tools and phantomjs
    ```
      Ubuntu
        apt-get install inotify-tools
        apt-get install phantomjs
      Fedora
        dnf install inotify-tools
    ```

### Language Support
We are currently supporting the following languages: pt_PT, es_ES, nl_NL and en.

In your html.eex place your text as: 
<%= gettext "Welcome to %{name}", name: "COCU" %> or
<%= gettext "Welcome to Cocu"%>

The text in the html corresponds to the msgid in priv/gettext/en/LC_MESSAGES/default.po
The translation is defined in the defaul.po after the msgid as msgstr.

For every text in any page, the corresponding translation must be defined!

To change the language you must specify it in the url. Ex: http://localhost:4000/?locale=pt_PT

### Specific javascript for each page
**Steps**
- First create the specific page js example: assets/js/views/projects.js
- Then go to assets/js/views/loader.js and import the new js file, example: import ProjectsView from './projects';
- Finally add the View to the list of views in the loader.js file. It must be the same name used in the views folder. Example int the lib/cocu_web/views/projects_view.exs, the view name is ProjectsView. That's the name you had in the loader.js

### Writing front-end tests with cypress
- Inside the folder /test/cypress/integration
- Create a .js file with the name of the module you are testing
- Then describe your test and add it's sub tests, according to the example in the same folder
- Run in one terminal ```$ MIX_ENV="test" iex -S mix phx.server ```
- Then go to the assets folder and run ```$ npm run cypress:run ```

If you want to see the testes running, in the second terminal run instead: ```$ npm run cypress:open ```

For more information: https://docs.cypress.io/guides/core-concepts/introduction-to-cypress.html#Cypress-Is-Simple

### Project Structure
```
├── _build
├── assets //This is where you place your css and js files
│   ├── css
│   │   └── pages
│   │   |    ├── _variables.scss // Global variables
│   │   |    └── _homepage.scss // Page specific css
│   │   └── app.scss // Here you import the css in the 'pages' folder
│   ├── js
│   │   └── app.js
│   └── static // Here you add images and other files
│   └── node_modules
│   └── vendor // Extra libraries can be placed here
├── config // Database and server config
├── deps // Project dependencies
├── lib
|   ├── cocu
|   |   ├── application.ex
|   |   └── repo.ex
|   ├── cocu_web
|   |   ├── channels
|   |   ├── controllers // Pages controllors
|   |   ├── templates // Html templates
|   |   ├── views
|   |   ├── endpoint.ex
|   |   ├── gettext.ex
|   |   └── router.ex // Project routes
├── priv
├── test

```

Ready to run in production? Please [check our deployment guides](http://www.phoenixframework.org/docs/deployment).

### For database configuration:
 * Development database: co-creative-universe/config/dev.exs 
 * Production database: co-creative-universe/config/prod.exs 
 * Testing database: co-creative-universe/config/test.exs 

## Learn more

  * Official website: http://www.phoenixframework.org/
  * Guides: http://phoenixframework.org/docs/overview
  * Docs: https://hexdocs.pm/phoenix


## Vision Statement

A world where everyone can follow their passion and propose projects that make the world a more beautiful place. A co-creative universe facilitates
the process of matching people with projects and projects with funding with a new cryptocurrency
that holds it's value into the benefit people generate for the collective.
The vision is a world that's open, transparent, collaborative and intrinsically motivated. 

## Short Description

A platform that enables communities to present projects for funding and that allows for voting. One of
the core aspects of the voting process is the contribution to the collective. Project initiators can share their perspective towards the way their projects makes the world a more beautiful place for the community to also tune into the value of it. The community at the same time can give feedback on the same parameters of contribution. The actual funding goes through a cryptocurrency, for instance through Waveswallet (https://waveswallet.io/) 


## Expected Results

In short there are 4 phases that all contain their technical functionality.
1. Presentation process 
  * A simple, yet functional and preferably nice looking platform to present project ideas and funding proposals within a closed and private setting.
2. Voting process 
    * A simple voting tool with the possibility to give feedback, comments and suggestions.
3. Funding process 
    * The decision making and setting process for funding.
4. Project development process and potential revolving money flow.
    * A platform to display the progress of projects and keep the community connected.
 

The impact has a huge potential on a local towards a global level. It has
the potential to replace the current banking system, with a connected community creation process. Money creation comes into the hands of communities rather than commercial organizations and individuals. This process will improve the transparency and honesty of the creation process
in the world. It will decentralize power structures and thereby improve the quality of communities. It introduces honest decision methods that enable
individuals and social entrepreneurs. Way of change: Awareness, in terms of the effect of projects and the potential impact they have. Well being; processes will be smoother, transparent and honest. No behind the scenes politics. Open processes that serve the collective.
The level of impact will be local and global at the same time. Local for closed communities being able to introduce these decision making systems. Global in two ways; the infrastructure will be available for communities all over the world. On top of that, there might be global communities to use these tools. This is an interesting an very political
introduction, that I can't oversee at the moment. Yet, with an intelligent voting system in place I'm sure we're able to serve the global human collective.
Type of innovation: disruptive solutions, by combining existing
technologies.
Value proposition: communities will pay a fee for organization costs to use
the software.
Growth potential: replicable and scalable. 

## Relevant Links

If you have additional information to refer, please add the URL's and links here, so
that we can access them and download. If needed, add respective credentials here as well.
http://creatingnewrealities.co

https://ewoudvenema2.wixsite.com/cocreativeuniverse
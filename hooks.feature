@ignore
Feature: Hooks

    @criarUsuario
    Scenario: Criar usuário - Hook
        * def name = "User name " + Date.now() 
        * def email = java.util.UUID.randomUUID() + "@t.com"
        * def payload = ({ name, email })

        Given url baseUrl + "/users"
        And request payload
        When method post
        Then status 201

    @criarUsuarioComNome
    Scenario: Criar usuário com nome - Hook
        * def email = java.util.UUID.randomUUID() + "@t.com" 
        * def payload = ({ name, email })

        Given url baseUrl + "/users"
        And request payload
        When method post
        Then status 201
        * def usuarioCriado = response

    @criarUsuarioComEmail
    Scenario: Criar usuário com nome - Hook
        * def name = "User name " + Date.now() 
        * def payload = ({ name, email })

        Given url baseUrl + "/users"
        And request payload
        When method post
        Then status 201
        * def usuarioCriado = response
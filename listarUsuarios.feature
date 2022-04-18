Feature: Listar usuários
    Como uma pessoa qualquer
    Desejo consultar todos os usuários cadastrados
    Para ter as informações de todos os usuários

    Background: Configurar request url
        Given url baseUrl
        And path "users"
    
    Scenario: Consultar usuários
        When method get
        Then status 200
        And match response == "#array"
        And match response contains { id: "#string", name: "#string", email: "#string", createdAt: "#string", updatedAt: "#string" }
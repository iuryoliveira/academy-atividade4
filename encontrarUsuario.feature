Feature: Encontrar usuário
    Como uma pessoa qualquer
    Desejo consultar os dados de um usuário
    Para visualizar as informações deste usuário

    Background: Configurar request url
        Given url baseUrl + "/users"

    Scenario: Deve ser possível consultar um usuário existente
        * def name = "User name " + Date.now() 
        * def email = java.util.UUID.randomUUID() + "@t.com"
        * def payload = ({ name, email })

        And request payload
        When method post
        Then status 201
        * def dadosUsuario = response

        Given path dadosUsuario.id
        When method get
        Then status 200
        And match response == dadosUsuario

    Scenario: Nenhuma informação deve ser retornada se o usuário não foi localizado
        * def id = java.util.UUID.randomUUID()
        Given path id
        When method get
        Then status 404
    
    Scenario: Não deve ser possível consultar usuário utilizando id inválido
        * def id = 1234
        Given path id
        When method get
        Then status 400
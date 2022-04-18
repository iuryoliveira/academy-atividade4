Feature: Remover usuário
    Como uma pessoa qualquer
    Desejo remover um usuário
    Para que suas informações não estejam mais registradas

    Background: Configurar request url
        Given url baseUrl + "/users"

    Scenario: Deve ser possível concluir a remoção mesmo que o usuário não seja localizado
        * def id = java.util.UUID.randomUUID()
        And path id
        When method delete
        Then status 204

    Scenario: Deve ser possível remover um usuário cadastrado
        * def responseCriacaoUsuario = call read("hooks.feature@criarUsuario")
        
        And path responseCriacaoUsuario.response.id
        When method delete
        Then status 204

        Given path responseCriacaoUsuario.response.id
        When method get
        Then status 404

Feature: Atualizar usuário
    Como uma pessoa qualquer
    Desejo atualizar as informações de determinado usuário
    Para ter o registro de suas informações atualizadas

    Background: Configurar request url
        Given url baseUrl + "/users"

    Scenario: Não deve ser possível atualizar se o usuário não for encontrado
        * def id = java.util.UUID.randomUUID()
        Given path id
        And request { name: "Nome atualizado", email: "email@atualizado.com" }
        When method put
        Then status 404

    Scenario Outline: Não deve ser possível atualizar usuário utilizando informações incompletas
        * def name = "User name " + Date.now() 
        * def email = java.util.UUID.randomUUID() + "@t.com"
        * def payload = ({ name, email })

        Given request payload
        When method post
        Then status 201
        * def id = response.id

        Given path id
        And request payloadAtualizacao
        When method put
        Then status 400

        Examples:
        | payloadAtualizacao!           |
        | {}                            |
        | { name: "Nome atualizado" }   |
        | { email: "email@atualizado" } |

    Scenario Outline: Não deve ser possível atualizar usuário com formato de e-mail inválido
        * def responseUsuarioCriado = callonce read("hooks.feature@criarUsuario")

        Given path responseUsuarioCriado.response.id
        And request { name: "Nome atualizado", email: "#(emailAtualizado)" }
        When method put
        Then status 400

        Examples: 
        | emailAtualizado | 
        | @t.com          |
        | i@.com          |
        | @it.            |

    Scenario: Não deve ser possível atualizar para um e-mail já utilizado
        * def responsePrimeiroUsuario = call read("hooks.feature@criarUsuario")
        * def responseSegundoUsuario = call read("hooks.feature@criarUsuario")
        
        Given path responseSegundoUsuario.response.id
        And request { name: "Nome atualizado", email: "#(responsePrimeiroUsuario.response.email)" }
        When method put
        Then status 422
        And match response == { error: "E-mail already in use." }

    Scenario Outline: Deve ser possível atualizar usuários para terem nome de no máximo 100 caracteres
        * def responseUsuarioCriado = call read("hooks.feature@criarUsuario")

        Given path responseUsuarioCriado.response.id
        And request { name: "#(name)", email: "#(responseUsuarioCriado.response.email)" }
        When method put
        Then match responseStatus == expectedStatus

        Examples:
        | expectedStatus! | name                                                                                                   |
        | 400             | iaushdausidashduiashdiausdausdhaiusdhaiudahsudihaiusdhaiudsnauiahsdiuahdusasdhuashhaasdasdhiauhdsiahd  |
        | 400             | iaushdausidashduiashdiausdausdhaiusdhaiudahsudihaiusdhaiudsnauiahsdiuahdusasdhuashhaasdasdhiauhdsiahd2 |
        | 200             | iaushdausidashduiashdiausdausdhaiusdhaiudahsudihaiusdhaiudsnauiahsdiuahdusasdhuashhaasdasdhiauhdsiah   |
        | 200             | iaushdausidashduiashdiausdausdhaiusdhaiudahsudihaiusdhaiudsnauiahsdiuahdusasdhuashhaasdasdhiauhdsi     |

    Scenario Outline: Deve ser possível atualizar usuários para terem e-mail de no máximo 100 caracteres
        * def responseUsuarioCriado = call read("hooks.feature@criarUsuario")
        * def name = responseUsuarioCriado.response.name
        * def randomEmail = java.util.UUID.randomUUID() + email

        Given path responseUsuarioCriado.response.id
        And request { name: "#(name)", email: "#(randomEmail)" }
        When method put
        Then match responseStatus == expectedStatus

        Examples:
        | expectedStatus! | email                      |
        | 400             | loremipsumlo@loremips.com  |
        | 400             | loremipsumlo@loremipsu.com |
        | 200             | loremipsumlo@loremip.com   |
        | 200             | loremipsumlo@loremi.com    |
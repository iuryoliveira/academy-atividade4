Feature: Criar usuário
    Como uma pessoa qualquer
    Desejo registrar informações de usuário
    Para poder manipular estas informações livremente

    Background: Configurar request url
        Given url baseUrl
        And path "users"

    Scenario: Não deve ser possível criar um usuário informando apenas o nome
        And request { name: "Iury" }
        When method post
        Then status 400

    Scenario: Não deve ser possível criar um usuário informando apenas o e-mail
        And request { email: "i@t.com" }
        When method post
        Then status 400

    Scenario Outline: Não deve ser possível criar usuários com formato de e-mail inválido
        And request { name: "User name", email: "#(email)" }
        When method post
        Then status 400

        Examples: 
        | email  | 
        | @t.com |
        | i@.com |
        | @it.   |

    Scenario Outline: Deve ser possível criar usuários apenas com nome contendo até 100 caracteres
        * def email = java.util.UUID.randomUUID() + "@t.com"
        And request { name: "#(name)", email: "#(email)" }
        When method post
        Then match responseStatus == expectedStatus

        Examples:
        | expectedStatus! | name |
        | 400             | iaushdausidashduiashdiausdausdhaiusdhaiudahsudihaiusdhaiudsnauiahsdiuahdusasdhuashhaasdasdhiauhdsiahd  |
        | 400             | iaushdausidashduiashdiausdausdhaiusdhaiudahsudihaiusdhaiudsnauiahsdiuahdusasdhuashhaasdasdhiauhdsiahd2 |
        | 201             | iaushdausidashduiashdiausdausdhaiusdhaiudahsudihaiusdhaiudsnauiahsdiuahdusasdhuashhaasdasdhiauhdsiah   |
        | 201             | iaushdausidashduiashdiausdausdhaiusdhaiudahsudihaiusdhaiudsnauiahsdiuahdusasdhuashhaasdasdhiauhdsi     |

    Scenario Outline: Deve ser possível criar usuários com e-mail de no máximo 60 caracteres
        * def randomEmail = java.util.UUID.randomUUID() + email

        And request { name: "Nome usuário", email: "#(randomEmail)" }
        When method post
        Then match responseStatus == expectedStatus

        Examples:
        | expectedStatus! | email                      |
        | 400             | loremipsumlo@loremips.com  |
        | 400             | loremipsumlo@loremipsu.com |
        | 201             | loremipsumlo@loremip.com   |
        | 201             | loremipsumlo@loremi.com    |

    Scenario: Deve ser possível criar um novo usuário utilizando informações válidas
        * def email = Date.now() + "@t.com"
        And request { name: "User name", email: "#(email)" }
        When method post
        Then status 201
        And match response == { id: "#uuid", name: "User name", email: "#(email)", createdAt: "#string", updatedAt: "#string" }

    Scenario: Não deve ser possível criar um novo usuário utilizando e-mail já existente
        * def email = java.util.UUID.randomUUID() + "@t.com"
        And request { name: "User name", email: "#(email)" }
        When method post
        Then status 201

        Given path "users"
        And request { name: "User name", email: "#(email)" }
        When method post
        Then status 422
        And match response == { error:  "User already exists." }



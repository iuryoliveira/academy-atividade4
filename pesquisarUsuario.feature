Feature: Pesquisar usuario
    Como uma pessoa qualquer
    Desejo pesquisar usuário por nome ou e-mail
    Para ser capaz de encontrar um usuário cadastrado facilmente

    Background: Configurar request url
        Given url baseUrl + "/search"

    Scenario Outline: Deve ser possível encontrar um usuário através do nome
        * def name = textoPesquisa + Date.now() 
        * def responseCriacaoUsuario = call read("hooks.feature@criarUsuarioComNome")

        Given param value = textoPesquisa
        When method get
        Then status 200
        And match response == "#array"
        And match response contains responseCriacaoUsuario.response

        Given param value = name
        When method get
        Then status 200
        And match response == "#array"
        And match response contains responseCriacaoUsuario.response

        Examples:
        | tipoPesquisa | textoPesquisa    |
        | nome         | Usuário pesquisa |

    Scenario Outline: Deve ser possível encontrar um usuário através do email
        * def email = textoPesquisa + java.util.UUID.randomUUID() + "@t.com" 
        * def responseCriacaoUsuario = call read("hooks.feature@criarUsuarioComEmail")

        Given param value = textoPesquisa
        When method get
        Then status 200
        And match response == "#array"
        And match response contains responseCriacaoUsuario.response

        Given param value = email
        When method get
        Then status 200
        And match response == "#array"
        And match response contains responseCriacaoUsuario.response

        Examples:
        | textoPesquisa  |
        | email.pesquisa |

    Scenario: Pesquisa não deve retornar resultados se nenhum usuário cadastrado respeitar coincidir com o critério de busca
        * def textoPesquisa = java.util.UUID.randomUUID() + "@emailNotFound.com" 

        Given param value = textoPesquisa
        When method get
        Then status 200
        And match response == "#array"
        And match karate.sizeOf(response) == 0

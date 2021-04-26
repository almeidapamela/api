require_relative "routes/sessions"
require_relative "helpers"

describe "POST /sessions" do
    context "E-mail e senha válidos" do
        before(:all) do
            payload = {email: "pamela@gmail.com", password: "123456"}
            @result = Sessions.new.login(payload)
        end
    
        it "Valida status code 200" do      

            expect(@result.code).to eql 200
        end

         it "Valida tamanho do id do usuário" do

            expect(@result.parsed_response["_id"].length).to eql 24
        end
    end

    # examples = [
    #     {
    #         title: "E-mail válido e senha inválida",
    #         payload: {email: "pamela@gmail.com", password: "12345"},
    #         code: 401,
    #         error: "Unauthorized",  
    #     },

    #     {
    #         title: "E-mail válido e senha em branco",
    #         payload: {email: "pamela@gmail.com", password: ""},
    #         code: 412,
    #         error: "required password",  
    #     },

    #     {
    #         title: "E-mail válido e sem senha",
    #         payload: {email: "pamela1@gmail.com"},
    #         code: 412,
    #         error: "required password",  
    #     },

    #     {
    #         title: "E-mail inexistente e senha válida",
    #         payload: {email: "pamela1@gmail.com", password: "123456"},
    #         code: 401,
    #         error: "Unauthorized",  
    #     },

    #     {
    #         title: "E-mail em branco e senha válida",
    #         payload: {email: "", password: "123456"},
    #         code: 412,
    #         error: "required email",  
    #     },

    #     {
    #         title: "Sem e-mail e senha válida",
    #         payload: {password: "123456"},
    #         code: 412,
    #         error: "required email",  
    #     }
    # ]

    #puts examples.to_json

    examples = Helpers::get_fixture("login")

    examples.each do |example|
        context "#{example[:title]}" do
            before(:all) do
                @result = Sessions.new.login(example[:payload])
            end
    
             it "Valida status code #{example[:code]} " do      
                expect(@result.code).to eql example[:code]
            end
            it "Valida mensagem de erro #{example[:error]}" do

                expect(@result.parsed_response["error"]).to eql example[:error]
            end
        end
    end
end
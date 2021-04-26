require_relative "routes/signup"
require_relative "libs/mongo"

describe "POST /signup" do
    context "novo usuário" do
        before(:all) do
            payload = {name: "QA Ninja", email: "qaninja100@qaninja.com.br", password: "123456"}
            MongoDB.new.remove_user(payload[:email])
            @result = Signup.new.create(payload)
        end
        it "Valida status code 200" do      

            expect(@result.code).to eql 200
        end

         it "Valida tamanho do id do usuário" do

            expect(@result.parsed_response["_id"].length).to eql 24
        end
    end

    context "e-mail já cadastrado" do
        before(:all) do
            #dado que eu tenho um novo usuário
            @payload = {name: "QA Ninja", email: "qaninja4@qaninja.com.br", password: "123456"}
            #e o e-mail deste usuário já foi cadastrado no sistema
            Signup.new.create(@payload)
            #quando faço uma requisição para a rota /signup
            @result = Signup.new.create(@payload)
        end

        it "Valida status code 409" do
            #então deve retornar 409
            expect(@result.code).to eql 409
        end
    
        it "Valida mensagem de erro" do
            expect(@result.parsed_response["error"]).to eql "Email already exists :("
            MongoDB.new.remove_user(@payload[:email])
        end    
    end

    examples = [
        {
            title: "Nome em branco",
            payload: {name: "", email: "qaninja4@qaninja.com.br", password: "123456"},
            code: 412,
            error: "required name",  
        },

        {
            title: "E-mail em branco",
            payload: {name: "QA Ninja", email: "", password: "123456"},
            code: 412,
            error: "required email",  
        },

        {
            title: "Senha em branco",
            payload: {name: "QA Ninja", email: "qaninja4@qaninja.com.br", password: ""},
            code: 412,
            error: "required password",  
        }
    ]

    examples.each do |example|
        context "#{example[:title]}" do
            before(:all) do
                @result = Signup.new.create(example[:payload])
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
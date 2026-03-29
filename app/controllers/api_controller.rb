class ApiController < ApplicationController
  def teste
    render json: { mensagem: "Backend funcionando!", status: "ok", timestamp: Time.now }
  end
end
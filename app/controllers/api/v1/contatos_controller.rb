# app/controllers/api/v1/contatos_controller.rb

class Api::V1::ContatosController < ApplicationController
  before_action :set_contato, only: [:show, :update, :destroy, :marcar_como_lido]

  # GET /api/v1/contatos
  def index
    @contatos = Contato.all.order(created_at: :desc)

    @contatos = @contatos.where(area: params[:area]) if params[:area].present?
    @contatos = @contatos.where(status: params[:status]) if params[:status].present?

    render json: {
      contatos: @contatos,
      total: @contatos.count,
      nao_lidos: Contato.where(status: "pendente").count
    }
  end

  # GET /api/v1/contatos/:id
  def show
    render json: @contato
  end

  # POST /api/v1/contatos
  def create
    @contato = Contato.new(contato_params)
    @contato.ip_remetente = request.remote_ip
    @contato.user_agent = request.user_agent
    @contato.status = "pendente"

    if @contato.save
      begin
        # Email para advogado
        ContatoMailer.notificacao_novo_contato(@contato).deliver_now

        # Email confirmação cliente
        ContatoMailer.confirmacao_recebimento(@contato).deliver_now

      rescue => e
        Rails.logger.error "ERRO MAILER: #{e.message}"
        Rails.logger.error e.backtrace.join("\n")
      end

      render json: {
        message: "Mensagem enviada com sucesso!",
        contato: @contato
      }, status: :created

    else
      render json: {
        errors: @contato.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  # PUT/PATCH /api/v1/contatos/:id
  def update
    if @contato.update(contato_params)
      if params[:status] == "lido" && @contato.data_leitura.blank?
        @contato.update(data_leitura: Time.current)
      end

      render json: {
        message: "Contato atualizado com sucesso",
        contato: @contato
      }

    else
      render json: {
        errors: @contato.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/contatos/:id
  def destroy
    @contato.destroy

    render json: {
      message: "Contato removido com sucesso"
    }
  end

  # POST /api/v1/contatos/:id/marcar_como_lido
  def marcar_como_lido
    @contato.update(
      status: "lido",
      data_leitura: Time.current
    )

    render json: {
      message: "Contato marcado como lido",
      contato: @contato
    }
  end

  # GET /api/v1/contatos/estatisticas
  def estatisticas
    render json: {
      total: Contato.count,
      pendentes: Contato.where(status: "pendente").count,
      lidos: Contato.where(status: "lido").count,
      respondidos: Contato.where(status: "respondido").count,
      por_area: Contato.group(:area).count
    }
  end

  private

  def set_contato
    @contato = Contato.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: {
      error: "Contato não encontrado"
    }, status: :not_found
  end

  def contato_params
    params.require(:contato).permit(
      :nome,
      :email,
      :telefone,
      :area,
      :assunto,
      :mensagem,
      :status
    )
  end
end
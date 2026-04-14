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
      nao_lidos: Contato.where(status: 'pendente').count
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
    @contato.status = 'pendente'
    
    if @contato.save
      begin
        ContatoMailer.notificacao_novo_contato(@contato).deliver_later
        ContatoMailer.confirmacao_recebimento(@contato).deliver_later
      rescue => e
        Rails.logger.error "Erro ao enviar e-mail: #{e.message}"
      end
      
      render json: { 
        message: "Mensagem enviada com sucesso! Você receberá um e-mail de confirmação.", 
        contato: @contato 
      }, status: :created
    else
      render json: { 
        errors: @contato.errors.full_messages 
      }, status: :unprocessable_entity
    end
  end
  
  # PATCH/PUT /api/v1/contatos/:id
  def update
    if @contato.update(contato_params)
      if params[:status] == 'lido' && @contato.pendente?
        @contato.update(data_leitura: Time.current)
      end
      
      render json: { 
        message: "Contato atualizado com sucesso", 
        contato: @contato 
      }
    else
      render json: { errors: @contato.errors.full_messages }, status: :unprocessable_entity
    end
  end
  
  # DELETE /api/v1/contatos/:id
  def destroy
    @contato.destroy
    render json: { message: "Contato removido com sucesso" }
  end
  
  # POST /api/v1/contatos/:id/marcar_como_lido
  def marcar_como_lido
    @contato.update(status: 'lido', data_leitura: Time.current)
    render json: { message: "Contato marcado como lido", contato: @contato }
  end
  
  # GET /api/v1/contatos/estatisticas
  def estatisticas
    render json: {
      total: Contato.count,
      pendentes: Contato.where(status: 'pendente').count,
      lidos: Contato.where(status: 'lido').count,
      respondidos: Contato.where(status: 'respondido').count,
      por_area: Contato.group(:area).count
    }
  end
  
  private
  
  def set_contato
    @contato = Contato.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Contato não encontrado" }, status: :not_found
  end
  
  def contato_params
    params.require(:contato).permit(:nome, :email, :telefone, :area, :assunto, :mensagem, :status)
  end
end
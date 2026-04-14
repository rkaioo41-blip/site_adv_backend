class Contato < ApplicationRecord
  # Validações
  validates :nome, presence: { message: "Nome é obrigatório" }
  validates :email, presence: { message: "E-mail é obrigatório" }
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP, message: "E-mail inválido" }
  validates :area, presence: { message: "Área de interesse é obrigatória" }
  validates :mensagem, presence: { message: "Mensagem é obrigatória" }
  
  # Callbacks
  before_create :setar_status_padrao
  
  private
  
  def setar_status_padrao
    self.status ||= 'pendente'
  end
end
class ContatoMailer < ApplicationMailer
  default from: 'advgjorgeluis@gmail.com'
  
  # E-mail de notificação para o administrador (você)
  def notificacao_novo_contato(contato)
    @contato = contato
    mail(
      to: 'advgjorgeluis@gmail.com',
      subject: "Novo contato do site - #{@contato.area} - #{@contato.nome}"
    )
  end
  
  # E-mail de confirmação para o usuário
  def confirmacao_recebimento(contato)
    @contato = contato
    mail(
      to: @contato.email,
      subject: "Recebemos sua mensagem - Escritório Jorge Luis"
    )
  end
end
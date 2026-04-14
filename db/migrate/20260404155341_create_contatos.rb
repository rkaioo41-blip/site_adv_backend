# db/migrate/20250404000001_create_contatos.rb
class CreateContatos < ActiveRecord::Migration[8.1]
  def change
    create_table :contatos do |t|
      t.string :nome, null: false
      t.string :email, null: false
      t.string :telefone
      t.string :area, null: false
      t.string :assunto
      t.text :mensagem, null: false
      t.string :status, default: 'pendente', null: false
      t.datetime :data_leitura
      t.string :ip_remetente
      t.string :user_agent

      t.timestamps
    end

    # Índices para performance
    add_index :contatos, :email
    add_index :contatos, :status
    add_index :contatos, :area
    add_index :contatos, :created_at
    add_index :contatos, [:status, :created_at], name: 'index_contatos_on_status_created_at'
  end
end
Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :contatos, only: [:create, :index, :show, :update, :destroy] do
        member do
          post :marcar_como_lido
        end
        collection do
          get :estatisticas
        end
      end
      resources :areas, only: [:index, :show]
      resources :equipe, only: [:index]
    end
  end

  # Rota de teste
  get "/api/teste", to: "api#teste"
end
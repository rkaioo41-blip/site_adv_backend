Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins "https://jorgeluis.adv.br", "https://www.jorgeluis.adv.br"

    resource "*",
      headers: :any,
      methods: [:get, :post, :put, :patch, :delete, :options, :head],
      credentials: false
  end
end
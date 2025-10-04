namespace :rabbit do
  desc 'Consume order.created events'
  task consume: :environment do
    OrderCreatedConsumer.new.start
  end
end

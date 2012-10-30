CanTango.config do |config|
  config.engines.all :on
  config.debug!
  config.engine(:permission).set :off
  config.engine(:cache).set :off
  config.ability.mode = :no_cache
  config.guest.user Proc.new { Guest.new }
  # more configuration here...
end

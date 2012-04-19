class Settings < Settingslogic
  source "#{Rails.root}/config/astrochimp.yml"
  namespace Rails.env
end

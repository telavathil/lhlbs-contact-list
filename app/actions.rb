# Homepage (Root path)
get '/' do
  erb :index
end

get '/contacts' do
  @contactsJson = Contact.all.as_json
  json @contactsJson
end

get '/contacts/:id' do
  #json for one contact
end

# Homepage (Root path)
get '/' do
  erb :index
end

get '/contacts' do
  @contactsJson = Contact.all.as_json
  json @contactsJson
end

post '/contact/new' do

  contact = Contact.new.from_json(params.to_json)

  contact.save
  @contactsJson = Contact.last.as_json
  json @contactsJson
end

get '/contact/:id' do
  #json for one contact
  @contactJson = Contact.find(params[:id]).as_json
  json @contactJson
end

put '/contact/delete/:id' do

end

put '/contact/edit/:id' do

end

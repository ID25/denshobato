# Denshobato - Private messaging between models.

![alt text](http://i.imgur.com/NuhMPrg.png "Denshobato")

##### [Install Gem](#install_gem)
##### [Tutorial](#-tutorial)
##### [Conversation API](#conversation)
##### [Message API](#message)
##### [Trash API](#trash)
##### [BlackList API](#blacklist)
##### [Controller Herper API](#controller)
##### [View Herper API](#view)
##### [Extensions](#extensions-1)

### Requirements
```
Rails 4.

Rails 3 isn't supported.
Not ready for 5, while it is in Beta.
```

### <a name="install_gem"> </a>Install Gem

```ruby
gem 'denshobato'
```
or

```gem install denshobato```

Then run installation:

```shell
rails g denshobato:install
```

Run migrations

```shell
rake db:migrate
```

Add this line to your model. This will make it able to send messages.
```ruby
denshobato_for :your_class
```

### <a name="tutorial"> </a>Tutorial
#### Create messaging system between reseller and customer.
[Part 1](http://id25.github.io/2016/03/01/make-private-dialog-between-reseller-and-customer-part-1.html)

[Part 2](http://id25.github.io/2016/03/02/make-private-dialog-between-reseller-and-customer-part-2.html)


### Example:
```ruby
class User < ActiveRecord::Base
  denshobato_for :user
end

class Customer < ActiveRecord::Base
  denshobato_for :customer
end
```

```ruby
@user.make_conversation_with(@customer).save

@user.send_message('Hello', @customer)
```

You're ready!

### <a name="conversation"></a>Conversations API

#####Create conversation with user

```ruby
current_user.make_conversation_with(customer)
# => #<Denshobato::Conversation id: nil, sender_id: 1, sender_type: "User", recipient_id: 1,
     #  recipient_type: "User", created_at: nil, updated_at: nil, trashed: false>

# Example:
# In your view:

- @users.each do |user|
  = link_to user.email, user if current_user != user
  = button_to 'Start Conversation', start_conversation_path(id: user.id, class: user.class.name),
    class: 'btn btn-success'

# Create route
# We need specify controller, because by default rails search for denshobato_conversations
post 'start_conversation', to: 'conversations#start_conversation', as: :start_conversation

# And action
def start_conversation
  recipient = params[:class].constantize.find(params[:id])
  conversation = current_account.make_conversation_with(recipient)

  if conversation.save
    redirect_to :conversations
  end
end
```

Another way to create a conversation.
```ruby

# In your view
# @conversation = current_user.hato_conversations.build

= form_for @conversation, url: :conversations do |form|
  = fill_conversation_form(form, user) # => denshobato view helper, for conversation creating
  = f.submit 'Start Conversation', class: 'btn btn-primary'

# Route, simple rest actions, i.e create for this.
resources :denshobato_conversations, as: :conversations,
  path: 'conversations', controller: 'conversations'

def create
  @conversation = current_account.hato_conversations.build(conversation_params)
  if @conversation.save
    redirect_to conversation_path(@conversation)
  else
    redirect_to :new, notice: 'Something went wrong'
  end
end
```

#####Fetch all conversations, where you're present.

```ruby
current_user.my_converstions
# => #<ActiveRecord::Relation [#<Denshobato::Conversation id: 118, sender_id: 1, sender_type: "User",
#      recipient_id: 2, recipient_type: "User", created_at: "2016-02-28 01:45:11",
#      updated_at: "2016-02-28 01:45:11", trashed: false>,
#    <Denshobato::Conversation id: 119, sender_id: 1, sender_type: "User", recipient_id: 1,
#      recipient_type: "Customer", created_at: "2016-02-28 02:05:59",
#      updated_at: "2016-02-28 02:05:59", trashed: false>]>
```

#####Find conversation with another user

```ruby
current_user.find_conversation_with(customer)
# => #<Denshobato::Conversation id: 119, sender_id: 1, sender_type: "User",
#      recipient_id: 1, recipient_type: "Customer",
#      created_at: "2016-02-28 02:05:59", updated_at: "2016-02-28 02:05:59", trashed: false>
```

#####Return all your trashed conversation
```ruby
current_user.trashed_conversations
# => #<ActiveRecord::Relation [#<Denshobato::Conversation id: 119, sender_id: 1, sender_type: "User",
#      recipient_id: 1, recipient_type: "Customer", created_at: "2016-02-28 02:05:59",
#      updated_at: "2016-02-28 02:21:48", trashed: true>]>
```

##### Return all messages from conversation
```ruby
@conversation.messages
# => [#<Denshobato::Message id: 224, body: "Hi", author_id: 1, author_type: "User",
#       created_at: "2016-02-28 00:51:00", updated_at: "2016-02-28 00:51:00">,
#     #<Denshobato::Message id: 225, body: "Hello", author_id: 1,
#       author_type: "Customer", created_at: "2016-02-28 00:53:11", updated_at: "2016-02-28 00:53:11">]
```

### <a name="message"></a>Messages API

```ruby
# This method sends message directly to the recipient
# Takes responsibility to create conversation if it doesn`t exist yet or sends message to an existing conversation

# Important!
# After each created message, send notification
if @message.save
  @message.send_notification(@conversation.id)
end
# See example below

msg = current_user.send_message(body: 'Hello', recipient)
# => #<Denshobato::Message:0x000000054dc790 id: nil, body: "Hello", author_id: 1,
#      author_type: "User", created_at: nil, updated_at: nil>
msg.save
```

Another way - send message directly to a conversation
```ruby
current_user.send_message_to(conversation.id, body: 'Hello')

# Example
# @message_form = current_user.hato_messages.build

= form_for @message_form, url: :messages do |form|
  = form.text_field :body, class: 'form-control'
  = fill_message_form(form, current_account, @conversation.id) # => denshobato helper, for message creating
  = form.submit 'Send message', class: 'btn btn-primary'

# Controller
def create
  conversation_id = params[:denshobato_message][:conversation_id]
  @message = current_account.send_message_to(conversation_id, message_params)

  if @message.save
  # Important, send notifications after save message
    @message.send_notification(conversation_id)
    redirect_to conversation_path(conversation_id)
  else
    render :new, notice: 'Error'
  end
end
```

### <a name="trash"></a>Trash API

##### Move conversation to trash and remove it out of there
```ruby
# @conversation.to_trash
# @conversation.from_tash

#Example
# In your view
- @conversations.each do |room|
  = link_to "Conversation with #{room.recipient.email}", conversation_path(room)
  = button_to 'Move to Trash', to_trash_path(id: room), class: 'btn btn-warning', method: :patch
  = button_to 'Move from Trash', from_trash_path(id: room), class: 'btn btn-warning', method: :patch

# Route
patch 'to_trash/:id',   to: 'conversations#to_trash',   as: :to_trash
patch 'from_trash/:id', to: 'conversations#from_trash', as: :from_trash

# In your conversation controller
%w(to_trash from_trash).each do |name|
  define_method name do
    room = Denshobato::Conversation.find(params[:id])
    room.send(name)
    redirect_to :conversations
  end
end
```

### <a name="blacklist"></a>BlackList API

```ruby
# current_user.add_to_blacklist(customer)
# current_user.remove_from_blacklist(customer)

- @users.each do |user|
  = link_to user.email, user if current_account != user
  - if user_in_black_list?(current_account, user)
    p This user in your blacklist
      = button_to 'Remove from black list', remove_from_blacklist_path(user: user,
        klass: user.class.name), class: 'btn btn-info'
  - else
      = button_to 'Add to black list', black_list_path(user: user, klass: user.class.name),
        class: 'btn btn-danger'

# Routes
post 'black_list/:user',            to: 'users#add_to_blacklist',      as: :black_list
post 'remove_from_blacklist/:user', to: 'users#remove_from_blacklist', as: :remove_from_blacklist

# Controller
[%w(add_to_blacklist save), %w(remove_from_blacklist destroy)].each do |name, action|
  define_method name do
    user   = params[:klass].constantize.find(params[:user])
    record = current_account.send(name, user)
    record.send(action) ? (redirect_to :users) : (redirect_to :root)
  end
end
```

### <a name="controller"></a>Controller Helpers

Check if user is already in conversation
```ruby
# user_in_conversation?(current_user, room)

# Example
@conversation = Denshobato::Conversation.find(params[:id])
unless user_in_conversation?(current_user, @conversation)
  redirect_to :conversations, notice: 'You can`t join this conversation'
end
```

Check if sender and recipient already have conversation together.
```ruby
# conversation_exists?(sender, recipient)

if conversation_exists?(current_user, @customer)
  do_somthing
end
```

Check if user can create conversation with other user
```ruby
# can_create_conversation?(sender, recipient)

if can_create_conversation?(current_user, @customer)
  @conversation_form = ...
end
```


### <a name="view"></a>View Helpers

Check if conversation exists, return `true` or `false`
```ruby
# @conversation = current_user.find_conversation(@user)

- if conversation_exists?(current_user, @user)
  = link_to 'Open chat', your_path(@conversation)
```

Check if user can create conversation with another user
```ruby
# can_create_conversation?(sender, recipient)

- if can_create_conversation?(current_user, @customer)
  = link_to 'Start Conversation', your_path...
```

Check if recipient is in blacklist
```ruby
# user_in_black_list?(sender, recipient)

- if user_in_black_list?(current_user, @customer)
  = button_to 'Remove from black list', remove_path...
```

Show name of recipient in conversation list
```ruby
- @conversations.includes(:sender).each do |room|
  = link_to "Conversation with: #{interlocutor_name(current_user, room, :first_name, :last_name)}",
    conversation_path(room)

# => Conversation with: John Doe
```

Show avatar for recipient
```ruby
= interlocutor_avatar(current_user, :user_avatar, @conversation, 'img-responsive')

# => <img src="..."/>
```

Show the last message, it's author and his avatar
```ruby
= "Last message: #{room.messages.last.try(:body)}"
  = "#{interlocutor_image(room.messages.last.try(:author), :user_avatar, 'img-circle')}"
  = "Last message from: #{message_from(room.messages.last, :first_name, :last_name)}"
```

Same inside of a conversation
```ruby
- @messages.includes(:author).each do |msg|
  p = interlocutor_info(msg.author, :fist_name, :last_name)
  = interlocutor_image(msg.author, :user_avatar, 'img-circle')
  p = msg.body
  hr
```

### Pagination
If you use Kaminari, or Will Paginate, just follow their guide.

Example:
```ruby
@messages = @conversation.messages.page(params[:page]).per(25)      # => Kaminari
@messages = @conversation.messages.page(params[:page]).per_page(25) # => Will Paginate
```

And in your view
```ruby
= paginate @messages      # => Kaminari
= will_paginate @messages # => Will Paginate
```

***

### <a name="extensions"></a>Extensions
![alt text](http://i.imgur.com/0sUUfDl.jpg "Screen")
Denshobato has addon [denshobato_chat_panel](https://github.com/ID25/denshobato_chat_panel). This is simple chat panel for you. If you don't need any special customization for dialog panel, or if you want to try messaging quickly, you can use chat panel.

That`s all for now.

## Upcoming features
+ Conference
+ Read/Unread messages

## Issues

If you've found a bug, or have proposal/feature request, create an issue with your thoughts.
[Denshobato Issues](https://github.com/ID25/denshobato/issues)

## Contributing

+ Fork it
+ Create your feature branch (git checkout -b my-new-feature)
+ Write tests for new feature/bug fix
+ Make sure that tests pass and everything works like a charm
+ Commit your changes (git commit -am 'Added some feature')
+ Push to the branch (git push origin my-new-feature)
+ Create new Pull Request

## The MIT License (MIT)

#### Denshobato - Private messaging between models.
![alt text](http://i.imgur.com/bo7kj7d.png "Denshobato")

Copyright (c) 2016 Eugene Domosedov (ID25)

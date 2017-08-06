u = User.create(name: "name", user_name: "zhangsan", mail: "y123@163.con", \
           number: 0,
           password: "12345678", password_confirmation: "12345678",
           icon: "emil.jpg")

z = Zone.create(name: "zone000", description: "this is a short description")
t = z.topics.create(topic_detail: "long topic", user: u)
(1..100).each do |n| 
  t.notes.create(note_detail: "233323333", floor: n, user: u)
end

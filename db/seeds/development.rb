u1 = User.create(name: "name", user_name: "zhangsan", mail: "y123@163.con", \
           number: 0, rank: 2,
           password: "12345678", password_confirmation: "12345678",
           icon: "emil.jpg")
u2 = User.create(name: "user2", user_name: "lisi", mail: "b123@1163.com", \
            number: 1, password: "12345678", password_confirmation: "12345678", \
               icon: "emil.jpg")

z = Zone.create(name: "zone000", description: "this is a short description")
z2 = Zone.create(name: "zone001", description: "this is zon 2")
#z.users << u1
#z2.users << u1
#z2.users << u2
#u1.zones << z
#u1.zones << z2
#u2.zones << z2
t = z.topics.create(topic_detail: "long topic", user: u1)
(1..100).each do |n|
  t.notes.create(note_detail: "233323333", floor: n, user: u1)
end

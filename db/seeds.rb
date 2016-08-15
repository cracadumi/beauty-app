User.create(email: 'admin@example.com', password: '1q2w3e4r', name: 'Admin',
            surname: '–', role: :user, password_confirmation: '1q2w3e4r',
            username: 'admin')
User.create(email: 'user@example.com', password: '1q2w3e4r', name: 'User',
            surname: 'Test', role: :admin, password_confirmation: '1q2w3e4r',
            username: 'user')
User.create(email: 'beautician@example.com', password: '1q2w3e4r',
            name: 'Beautician', surname: 'Test', role: :beautician,
            password_confirmation: '1q2w3e4r', username: 'beautician')


const isAdmin = (user) => {
  
    return user.role === 'admin';
};

module.exports = {isAdmin};

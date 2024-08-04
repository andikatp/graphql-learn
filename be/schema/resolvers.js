// A map of functions which return data for the schema.
import { Users, Movies } from '../fake-data.js';
import _ from 'lodash';

const resolvers = {
    Query: {
        users: () => Users,
        user: (__, { id }) => _.find(Users, { id: Number(id) }),
        movies: () => Movies,
        movie: (__, { name }) => _.find(Movies, { name }),
    },
    User: {
        favoriteMovies: () => {
            return _.filter(Movies, { isInTeather: true });
        }
    },
    Mutation: {
        createUser: (__, args) => {
            const newUser = args.input
            const id = _.last(Users).id + 1;
            newUser.id = id;
            _.add(Users, newUser);
            _.
                Users.push(newUser);
            return newUser;
        },
        updateUserName: (__, { input }) => {
            const id = Number(input.id);
            const user = _.find(Users, { id });
            user.username = input.userName;
            return user;
        },
        deleteUser: (__, { input }) => {
            const id = Number(input.id);
            const user = _.find(Users, { id });
            _.remove(Users, user);
            return user;
        }
    }
};

export default resolvers
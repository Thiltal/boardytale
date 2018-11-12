import {BoardytaleConfiguration} from './config';
import * as fs from 'fs';

export let config: BoardytaleConfiguration = {
    aiService: {
        uri: null,
        uris: ['http://localhost:5000'],
        route: null,
        innerRoute: '/innerApi'
    },
    database: {
        host: 'localhost',
        password: 'devdb',
        username: 'devdb',
        port: 5432
    },
    editorServer: {
        uri: 'http://localhost:9000',
        innerRoute: '/innerApi',
        route: '/editorApi'
    },
    gameServer: {
        uri: 'http://localhost:7000',
        innerRoute: '/innerApi',
        route: '/gameApi',
    },
    userService: {
        uri: 'http://localhost:6000',
        innerRoute: '/innerApi',
        route: '/userApi'
    },
    editorStaticDev: {
        active: true,
        proxyPass: '/editor',
        route: 'http://localhost:4300'
    },
    gameStaticDev: {
        active: true,
        proxyPass: '/game',
        route: 'http://localhost:4200'
    }
};

fs.writeFileSync('dev-config.json', JSON.stringify(config));

export const isAdmin = (req, res, next) => {
    if (req.session.auth && req.session.authUser.isAdmin) {
        return next(); // Cho phép truy cập nếu là Admin
    }
    return res.status(403).send('Forbidden: You do not have access to this resource.'); // Không cho phép truy cập
};

export const isEditor = (req, res, next) => {
    if (req.session.auth && req.session.authUser.isEditor) {
        return next(); // Cho phép truy cập nếu là Editor
    }
    return res.status(403).send('Forbidden: You do not have access to this resource.'); // Không cho phép truy cập
};

export const isWriter = (req, res, next) => {
    if (req.session.auth && req.session.authUser.isWriter) {
        return next(); // Cho phép truy cập nếu là Writer
    }
    return res.status(403).send('Forbidden: You do not have access to this resource.'); // Không cho phép truy cập
};

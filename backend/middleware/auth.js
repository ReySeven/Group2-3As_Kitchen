// auth.js — session-based authentication middleware

export const requireAuth = (req, res, next) => {
    if (!req.session || !req.session.user) {
        return res.status(401).json({ error: 'Not authenticated. Please log in.' });
    }
    req.user = req.session.user;
    next();
};

export const requireRole = (...roles) => (req, res, next) => {
    if (!roles.includes(req.user?.role)) {
        return res.status(403).json({ error: 'Access denied.' });
    }
    next();
};

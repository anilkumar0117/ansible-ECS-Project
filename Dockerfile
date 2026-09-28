# ---- Stage 1: build the React frontend ----
FROM node:20-alpine AS frontend-build
WORKDIR /app/frontend
COPY frontend/package*.json ./
RUN npm install
COPY frontend/ ./
RUN npm run build

# ---- Stage 2: backend + built frontend, single runtime image ----
FROM node:20-alpine
WORKDIR /app

COPY backend/package*.json ./
RUN npm install --production

COPY backend/ ./

# Drop the built React app into backend/public - server.js serves it directly
COPY --from=frontend-build /app/frontend/dist ./public

EXPOSE 5000
CMD ["node", "server.js"]

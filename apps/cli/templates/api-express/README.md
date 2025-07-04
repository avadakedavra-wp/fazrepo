# {{PROJECT_NAME}}

{{PROJECT_DESCRIPTION}}

## 🚀 Features

- **Express.js** with TypeScript
- **Input validation** with Zod
- **Error handling** middleware
- **CORS** support
- **Security** with Helmet
- **Logging** with Morgan
- **Testing** setup with Jest
- **Authentication** with JWT

## 🛠️ Tech Stack

- **Runtime**: Node.js with TypeScript
- **Framework**: Express.js
- **Validation**: Zod
- **Authentication**: JWT with bcrypt
- **Testing**: Jest
- **Security**: Helmet, CORS
- **Logging**: Morgan

## 📦 Installation

1. **Install dependencies**:
   ```bash
   npm install
   ```

2. **Set up environment variables**:
   ```bash
   cp .env.example .env
   ```

3. **Start the development server**:
   ```bash
   npm run dev
   ```

## 🔧 Available Scripts

- `npm run dev` - Start development server with hot reload
- `npm run build` - Build for production
- `npm run start` - Start production server
- `npm run test` - Run tests
- `npm run test:watch` - Run tests in watch mode
- `npm run lint` - Run ESLint
- `npm run lint:fix` - Fix ESLint issues

## 📁 Project Structure

```
src/
├── index.ts          # Application entry point
├── routes/           # API route handlers
├── middleware/       # Express middleware
├── types/           # TypeScript type definitions
├── utils/           # Utility functions
└── tests/           # Test files
```

## 🔐 Environment Variables

Create a `.env` file with the following variables:

```env
PORT=3000
NODE_ENV=development
JWT_SECRET=your-secret-key
CORS_ORIGIN=http://localhost:3000
```

## 🧪 Testing

Run tests with:
```bash
npm test
```

Run tests in watch mode:
```bash
npm run test:watch
```

## 📝 License

{{LICENSE}}

## 👨‍�� Author

{{AUTHOR}} 
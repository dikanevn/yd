import * as fs from 'fs';
import * as path from 'path';
import { fileURLToPath } from 'url';

// Получаем текущую директорию
const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

// Функция для создания метаданных NFT
function createNftMetadata(index) {
  return {
    name: `Yapster Dimensions #${index}`,
    symbol: `YAPDIM`,
    image: `https://yapster-dimensions.xyz/png/${index}.png`
  };
}

// Основная функция
async function main() {
  const uriDir = path.join(process.cwd(), 'uri');
  
  // Создаем директорию uri, если она не существует
  if (!fs.existsSync(uriDir)) {
    fs.mkdirSync(uriDir, { recursive: true });
    console.log('Создана директория uri');
  }
  
  // Генерируем 100 файлов метаданных
  for (let i = 0; i <= 3000; i++) {
    const metadata = createNftMetadata(i);
    const filePath = path.join(uriDir, `${i}.json`);
    
    fs.writeFileSync(filePath, JSON.stringify(metadata, null, 2));
    console.log(`Создан файл метаданных: ${filePath}`);
  }
  
  console.log('Генерация метаданных завершена!');
}

// Запускаем скрипт
main().catch(error => {
  console.error('Ошибка:', error);
  process.exit(1);
}); 
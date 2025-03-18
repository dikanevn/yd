import * as fs from 'fs';
import * as path from 'path';

// Основная функция
async function main() {
  const sourceImagePath = './dnf.png';
  const pngDir = path.join(process.cwd(), 'png');
  
  // Проверяем, существует ли исходный файл
  if (!fs.existsSync(sourceImagePath)) {
    console.error(`Ошибка: Исходный файл не найден: ${sourceImagePath}`);
    process.exit(1);
  }
  
  // Создаем директорию png, если она не существует
  if (!fs.existsSync(pngDir)) {
    fs.mkdirSync(pngDir, { recursive: true });
    console.log('Создана директория png');
  }
  
  // Читаем исходный файл
  const imageData = fs.readFileSync(sourceImagePath);
  
  // Копируем файл с номерами от 1 до 10
  for (let i = 0; i <= 3000; i++) {
    const destFilePath = path.join(pngDir, `${i}.png`);
    fs.writeFileSync(destFilePath, imageData);
    console.log(`Создан файл изображения: ${destFilePath}`);
  }
  
  console.log('Копирование изображений завершено!');
}

// Запускаем скрипт
main().catch(error => {
  console.error('Ошибка:', error);
  process.exit(1);
}); 